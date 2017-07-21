component extends="wheels.tests.Test" {

	function setup() {
		oldViewPath = application.wheels.viewPath;
		application.wheels.viewPath = "wheels/tests/_assets/views";
	}

	function teardown() {
		application.wheels.viewPath = oldViewPath;
	}

	function test_visit_with_existing_view() {
		actual = visit("/main/template");
		assert("actual.status == 200");
		assert("actual.controller == 'main'");
		assert("actual.action == 'template'");
		assert("actual.route == 'wildcard'");
		assert("actual.body contains 'main controller template content'");
	}

	function test_visit_with_query_string() {
		actual = visit("/main/template?foo=bar");
		assert("actual.params.foo == 'bar'");
	}

	function test_visit_root() {
		// because a bare wheels app will have no views, I need to test that the correct error is returned
		try {
			actual = visit("/");
		} catch (any e) {
			actual = e
		}
		assert("actual.message == 'Could not find the view page for the `wheels` action in the `Wheels` controller.'");
	}

}
