//Width and height of plot
var width = 500;
var height = 500;

d3.select("div#plot")
			.append("svg")
			.attr("id", "demo")
			.attr("width", width)
			.attr("height", height);

d3.select("svg#demo")
  .append("rect")
  .attr("x", "0")
  .attr("y", "0")
  .attr("width", "300")
  .attr("height", "200")
  .attr("fill", "lightblue")

d3.select("svg#demo")
  .append("circle")
    .attr("cx", "-25")              
    .attr("cy", "100")
    .attr("r", "20")
    .attr("fill", "red")
  .transition()
  .duration(3000)
    .attr("cx", "325")
  .remove();