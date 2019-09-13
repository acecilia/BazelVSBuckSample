# This file can be depended upon for any apple_test_lib rules.
genrule(
  name = "info_plist",
  visibility = ["PUBLIC"],
  srcs = [
      "Info.plist",
  ],
  out = 'Info.plist',
  cmd = 'cp $SRCDIR/Info.plist $OUT',
)