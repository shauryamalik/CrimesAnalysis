var w = 700;
var h = 600;
var padding = 10;

var xScale = d3.scaleLinear()
				.domain([-74.4,-73.6])
				.range([0,w*0.8]);

var yScale = d3.scaleLinear()
				.domain([40.5, 40.9])
				.range([h*0.8, padding])

var yAxis = d3.axisLeft()
				.scale(yScale);

var xAxis = d3.axisBottom()
				.scale(xScale);

var svg = d3.select("div#plot")
				.append("svg")
				.attr("id", "demo")
				.attr("width", w)
				.attr("height", h);

svg.append("g")
	.attr("transform", `translate(${w*0.1}, ${padding})`)
	.call(yAxis);

svg.append("g")
	.attr("transform", `translate(${w*0.1}, ${h*0.8+padding})`)
 	.call(xAxis);

datasrc = "https://raw.githubusercontent.com/shauryamalik/CrimesAnalysis/main/datasets/NYPD_Arrest_Data__Year_to_Date_.csv"

d3.csv(datasrc)
  .then(function(data) {
	// stuff that requires the loaded data

  })
  .catch(function(error) {
		// error handling  
  
  });