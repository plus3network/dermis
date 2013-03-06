require "shelljs/global"

fname = "test/plztestme/dermis.js"
toMatch = 'require.register("dermis'

file = "//#JSCOVERAGE_IF 0\r\n" + cat "dermis.js"
file = file.replace toMatch, "//#JSCOVERAGE_ENDIF\r\n#{toMatch}"
mkdir "test/plztestme"
file.to fname