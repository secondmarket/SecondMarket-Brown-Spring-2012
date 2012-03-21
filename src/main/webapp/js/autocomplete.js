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
			{ label: "San Fransisco, CA" }
		];
		$("#tags").autocomplete({
			source: availableTags,
      select: function(event, ui) {
        // TODO: Change to AJAX request
        var getParam = ui.item.value.substring(0, ui.item.value.indexOf(','));
        window.location = "?" + encodeURIComponent(getParam);
      }
		});
});
