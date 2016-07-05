# based on: docker-library/official-images/test/tests/mongo-basics/run.sh

fatal() { echo "fatal [$(basename $BATS_TEST_FILENAME)]: $@" 1>&2; exit 1; }

[ "$IMAGE" ] || fatal "IMAGE envvar not set"
[ "$(docker images -q $IMAGE | wc -l)" = "1" ] || fatal "$IMAGE not in cache"

mongo() {
    docker run --rm -i --link "$CNAME":mongo "$IMAGE" mongo --host mongo "$@"
}

mongo_eval() {
    mongo --quiet --eval "$@"
}

_init() {
    export TEST_SUITE_INITIALIZED=y

    echo >&2 "init: running $IMAGE"
    export CNAME="mongodb-$RANDOM-$RANDOM"
    export CID="$(docker run -d --name "$CNAME" "$IMAGE")"
    trap "docker rm -vf $CID > /dev/null" EXIT

    echo -n >&2 "init: waiting for $IMAGE to accept connections"
    tries=10
    while ! mongo_eval 'quit(db.stats().ok ? 0 : 1);' &> /dev/null; do
        (( tries-- ))
        if [ $tries -le 0 ]; then
            echo >&2 "$IMAGE failed to accept connections in wait window!"
            ( set -x && docker logs "$CID" ) >&2 || true
            mongo --eval 'db.stats();' # hopefully get a useful error message
            false
        fi
        echo >&2 -n .
        sleep 2
    done
    echo
}
[ -n "$TEST_SUITE_INITIALIZED" ] || _init


@test "db.test is empty" {
    [ "$(mongo_eval 'db.test.count();')" = 0 ]
}

@test "db.test create entry and verify" {
    run mongo_eval 'db.test.save({ _id: 1, a: 2, b: 3, c: "hello" });'
    [ $status -eq 0 ]
    [ "$(mongo_eval 'db.test.count();')" = 1 ]
}

@test "db.test overwrite entry and verify" {
    run mongo_eval 'db.test.save({ _id: 1, a: 3, b: 4, c: "hello" });'
    [ $status -eq 0 ]
    [ "$(mongo_eval 'db.test.count();')" = 1 ]
}

@test "db.test find key and verify value" {
    [ "$(mongo_eval 'db.test.findOne().a;')" = 3 ]
}

@test "db.test2 is empty" {
    [ "$(mongo_eval 'db.test2.count();')" = 0 ]
}

@test "db.test2 create entry and verify" {
    run mongo_eval 'db.test2.save({ _id: "abc" });' > /dev/null
    [ $status -eq 0 ]
    [ "$(mongo_eval 'db.test2.count();')" = 1 ]
}

@test "db.test count verify" {
    [ "$(mongo_eval 'db.test.count();')" = 1 ]
}

@test "db.test2 drop and verify" {
    run mongo_eval 'db.test2.drop();'
    [ $status -eq 0 ]
    [ "$(mongo_eval 'db.test2.count();')" = 0 ]
}

@test "db.test count verify" {
    [ "$(mongo_eval 'db.test.count();')" = 1 ]
}

@test "db.test count verify" {
    [ "$(mongo_eval 'db.test.count();')" = 1 ]
}

@test "db.test count verify" {
    [ "$(mongo_eval 'db.test.count();')" = 1 ]
}

@test "nonexistent database" {
    [ "$(mongo_eval 'db.test.count();' nonexistent-database)" = 0 ]
}

@test "drop database and verify" {
    run mongo_eval 'db.dropDatabase();'
    [ $status -eq 0 ]
    [ "$(mongo_eval 'db.test.count();')" = 0 ]
}

