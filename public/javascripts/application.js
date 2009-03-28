
function selectAccount() {
	sel = $("accountSelect");
	id = sel.options[sel.selectedIndex].value;
	if (id) {
		if (id == "0") {
			uri = "/manitu/users"
		}
		else {
			uri = "/manitu/base/set_account/" + id;
		}
		location.href = uri;
	}
}