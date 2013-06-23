build: components lib
	@rm -rf dist
	@mkdir dist
	@node_modules/.bin/coffee -b -o dist -c lib/*.coffee
	@node_modules/.bin/component build --standalone dermis
	@mv build/build.js dermis.js
	@rm -rf build
	@node_modules/.bin/uglifyjs -nc --unsafe -mt -o dermis.min.js dermis.js
	@echo "File size (minified): " && cat dermis.min.js | wc -c
	@echo "File size (gzipped): " && cat dermis.min.js | gzip -9f  | wc -c
	@cp ./dermis.js ./example

test: build lib
	node_modules/.bin/coffee -b -o test/lib -c test/src/*.coffee
	rm -rf test/plztestme
	node_modules/.bin/coffee test/fixCoverage.coffee
	rm -rf test/deps-cov
	-jscoverage test/plztestme test/deps-cov
	-pkill -9 -f test/server.coffee
	node_modules/.bin/coffee test/server.coffee &
	node_modules/.bin/mocha-phantomjs --reporter dot ./test/runner.html -s localToRemoteUrlAccessEnabled=true -s webSecurityEnabled=false
	-node_modules/.bin/mocha-phantomjs --reporter json-cov ./test/runner.html -s localToRemoteUrlAccessEnabled=true -s webSecurityEnabled=false | json2htmlcov > test/coverage.html
	-pkill -9 -f test/server.coffee

components: component.json
	@node_modules/.bin/component install --dev

docs: lib
	@node_modules/.bin/lidoc README.md manual/*.md lib/*.coffee --output docs --github wearefractal/dermis

docs.deploy: docs
	@cd docs && \
  git init . && \
  git add . && \
  git commit -m "Update documentation"; \
  git push "https://github.com/wearefractal/dermis" master:gh-pages --force && \
  rm -rf .git

clean:
	@rm -rf test/deps-cov
	@rm -rf test/plztestme
	@rm -rf components
	@rm -rf build
	@rm -rf docs

.PHONY: test docs docs.deploy