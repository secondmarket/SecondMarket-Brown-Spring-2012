$(function() {
		var availableTags = [
      { value: "Austin", label: "Austin, TX" },
			{ value: "Boston", label: "Boston, MA" },
			{ value: "Cambridge", label: "Cambridge, MA" },
			{ value: "Chicago", label: "Chicago, IL" },
			{ value: "Mountain%20View", label: "Mountain View, CA" },
			{ value: "New%20York", label: "New York, NY" },
			{ value: "Palo%20Alto", label: "Palo Alto, CA" },
			{ value: "Seattle", label: "Seattle, WA" },
			{ value: "San%20Fransisco", label: "San Fransisco, CA" }
		];
		$("#tags").autocomplete({
			source: availableTags,
      select: function(event, ui) {
        // TODO: Change to AJAX request
        window.location = "?" + ui.item.value;
      }
		});
});
