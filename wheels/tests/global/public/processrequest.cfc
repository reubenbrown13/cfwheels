component extends="wheels.tests.Test" {

	function setup() {
		savedViewPath = application.wheels.viewPath;
		savedRoutes = duplicate(application.wheels.routes);
		application.wheels.viewPath = "wheels/tests/_assets/views";
		application.wheels.routes = [];
	}

	function teardown() {
		application.wheels.viewPath = savedViewPath;
		application.wheels.routes = savedRoutes;
	}

	function test_process_request() {
		local.params = {
			action = "show",
			controller = "csrfProtectedExcept"
		};
		result = processRequest(local.params);
		expected = "Show ran";
		assert("Find(expected, result)");
	}

	function test_process_request_return_as_struct() {
		local.params = {
			action = "show",
			controller = "csrfProtectedExcept"
		};
		result = processRequest(params=local.params, returnAs="struct").status;
		expected = 200;
		assert("Compare(expected, result) eq 0");
	}

	function test_process_request_as_get() {
		local.params = {
			action = "actionGet",
			controller = "verifies"
		};
		result = processRequest(method="get", params=local.params);
		expected = "actionGet";
		assert("Find(expected, result)");
	}

	function test_process_request_as_post() {
		local.params = {
			action = "actionPost",
			controller = "verifies"
		};
		result = processRequest(method="post", params=local.params);
		expected = "actionPost";
		assert("Find(expected, result)");
	}

	function test_process_request_url_argument_with_existing_view() {
		pattern = "/main/template";
		mapper()
			.get(to="main##template", pattern=pattern)
		.end();
		actual = processRequest(url=pattern, returnAs="struct");

		assert("actual.status == 200");
		assert("actual.controller == 'main'");
		assert("actual.action == 'template'");
		assert("actual.body contains 'main controller template content'");
	}

	function test_process_request_url_argument_with_query_string() {
		mapper()
			.get(to="main##template", pattern="/main/template")
		.end();
		actual = processRequest(url="/main/template?foo=bar", returnAs="struct");
		assert("actual.params.foo == 'bar'");
	}

	function test_process_url_argument_request_root() {
		mapper()
			.root(to="main##template")
		.end();
		actual = processRequest(url="/", returnAs="struct");

		assert("actual.body contains 'main controller template content'");
	}

	function test_process_request_url_posted_params_remain_with_querystring_use() {
		mapper()
			.post(to="main##template", pattern="/main/template")
		.end();
		local.params = {
			posted = "true",
			foo = "bar"
		};
		actual = processRequest(url="/main/template?foo=false", method="post", params=local.params, returnAs="struct");

		assert("actual.params.posted == 'true'");
		assert("actual.params.foo == 'bar'");
	}

}
