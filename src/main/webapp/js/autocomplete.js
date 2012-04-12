$(function() {
		$("#tags").autocomplete({
      source: function(request, response) {
				$.ajax({
					url: "/autocomplete.htm",
					dataType: "json",
					data: {
						maxRows: 15,
						startsWith: request.term
					},
					success: function(data) {
						response(data);
					}
				});
			},
      minLength: 2,
      select: function(event, ui) {
        if (ui.item.type === "c") { // company
          window.location = "/companies/" + ui.item.value + ".htm";
        } else if (ui.item.type === "l") { // location
          if (window.location.href.indexOf("industry/") === -1) {
            window.location = "/industry/all.htm?" + encodeURIComponent(ui.item.value);
          } else {
            window.location = "?" + encodeURIComponent(ui.item.value);
          }
        }
      }
		});
});
