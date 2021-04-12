var boroughs = ["Bronx", "Brooklyn", "Staten Island", "Manhattan", "Queens"];

datasrc = "https://raw.githubusercontent.com/shauryamalik/CrimesAnalysis/main/datasets/filtered/arrests_by_offenses_and_borough.csv";

d3.csv(datasrc)
  .then(function(data) {
	// stuff that requires the loaded data
	var offenseMap = {};
	data.forEach(function(d) {
	    var offense = d.OFNS_DESC;
	    offenseMap[offense] = [];
	    boroughs.forEach(function(field) {
	        offenseMap[offense].push( +d[field] );
	    });
	});
	makeVis(offenseMap);
  })
  .catch(function(error) {
		// error handling  
  });

var makeVis = function(offenseMap) {
	var margin = { top: 30, right: 50, bottom: 30, left: 50 };
    var width  = 700 - margin.left - margin.right;
    var height = 600 - margin.top  - margin.bottom;

	// var w = 700;
	// var h = 600;
	var padding = 10;

	var xScale = d3.scaleBand()
					.domain(boroughs)
					.range([0,width]);

	var yScale = d3.scaleLinear()
					//.domain([40.5, 40.9])
					.range([height, padding])

	var yAxis = d3.axisLeft()
					.scale(yScale);

	var xAxis = d3.axisBottom()
					.scale(xScale);

	// // var svg = d3.select("div#plot")
	// // 				.append("svg")
	// // 				.attr("id", "demo")
	// // 				.attr("width", w)
	// // 				.attr("height", h);

	// svg.append("g")
	// 	.attr("transform", `translate(${w*0.1}, ${padding})`)
	// 	.call(yAxis);

	// svg.append("g")
	// 	.attr("transform", `translate(${w*0.1}, ${h*0.8+padding})`)
	//  	.call(xAxis);

 	// Create svg
    var svg = d3.select("#vis-container")
				      .append("svg")
				        .attr("width",  width  + margin.left + margin.right)
				        .attr("height", height + margin.top  + margin.bottom)
				      .append("g")
				        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", `translate(0, ${height})`)
        .call(xAxis);

    svg.append("g")
    	.attr("class", "y axis")
		.attr("transform", `translate(0, 0)`)
		.call(yAxis);

	var updateBars = function(data) {
        // First update the y-axis domain to match data
        yScale.domain( d3.extent(data) );
        svg.append("g")
	    	.attr("class", "y axis")
			.attr("transform", `translate(0, 0)`)
			.call(yAxis);

        var bars = svg.selectAll(".bar").data(data);

        // Add bars for new data
        bars.enter()
          .append("rect")
            .attr("class", "bar")
            .attr("x", function(d,i) { return xScale( boroughs[i] )+55; })
            .attr("width", 20)
            .attr("y", function(d,i) { return yScale(d); })
            .attr("height", function(d,i) { return height- yScale(d); }); // - yScale(d.Brooklyn)

        // Update old ones, already have x / width from before
        bars
            .transition().duration(250)
            .attr("y", function(d,i) { return yScale(d); })
            .attr("height", function(d,i) { return height- yScale(d); }); // - yScale(d.Brooklyn)

        // Remove old ones
        bars.exit().remove();
    };

    // Handler for dropdown value change
    var dropdownChange = function() {
        var newOffense = d3.select(this).property('value'),
            newData   = offenseMap[newOffense];

        updateBars(newData);
    };

    // Get names of offenses, for dropdown
    var offenses = Object.keys(offenseMap).sort();

    var dropdown = d3.select("#vis-container")
        .insert("select", "svg")
        .on("change", dropdownChange);

    dropdown.selectAll("option")
        .data(offenses)
        .enter().append("option")
        .attr("value", function (d) { return d; })
        .text(function (d) {
            return d;//[0].toUpperCase() + d.slice(1,d.length); // capitalize 1st letter
        });

    var initialData = offenseMap[ offenses[0] ];
    updateBars(initialData);
};