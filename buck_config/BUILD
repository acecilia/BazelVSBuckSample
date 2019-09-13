# This file can be depended upon for any apple_test_lib rules.
genrule(
  name = "info_plist",
  visibility = ["PUBLIC"],
  srcs = [
      "BuckSupportFiles/Info.plist",
  ],
  out = 'Info.plist',
  cmd = 'cp $SRCDIR/BuckSupportFiles/Info.plist $OUT',
)