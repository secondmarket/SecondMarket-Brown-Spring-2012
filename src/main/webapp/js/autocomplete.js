$(function() {
		var availableTags = [
      { label: "Austin, TX" },
			{ label: "Boston, MA" },
			{ label: "Cambridge, MA" },
			{ label: "Chicago, IL" },
			{ label: "Mountain View, CA" },
			{ label: "New York, NY" },
			{ label: "Palo Alto, CA" },
			{ label: "Seattle, WA" },
			{ label: "San Francisco, CA" }
		];
		$("#tags").autocomplete({
			source: "/autocomplete.htm",
      minLength: 2,
      select: function(event, ui) {
        // TODO: Both companies and locations
        //var getParam = ui.item.value.substring(0, ui.item.value.indexOf(','));
        //window.location = "?" + encodeURIComponent(getParam);
        window.location = "/companies/" + ui.item.value + ".htm";
      }
		});
});
