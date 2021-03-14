## Notes

```
./test/test.sh workflow_dispatch -e <(echo '{"inputs":{"version":"23.2.7"}}')  -r
gh api -XPOST repos/wojtekmach/beamup2/actions/workflows/build_otp.yml/dispatches --input <(echo '{"ref":"master","inputs":{"version":"23.2.7"}}')
```
