## update changelog, create signed tag and push to github

```
contrib/generate-changelog > CHANGELOG.tmp
mv CHANGELOG.tmp CHANGELOG.md
$EDITOR CHANGELOG.md # verify version is correct and tweak 
VERSION=$(head -1 CHANGELOG.md | awk '{print $2}')
git add CHANGELOG.md
git commit -m "changelog: updated for $VERSION release"
git tag -s -m "$VERSION release" $VERSION
git push github
git push github --tags
```

