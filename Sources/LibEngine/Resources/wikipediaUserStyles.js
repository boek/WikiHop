console.log("boek loaded 2")
var style = document.createElement('style');
style.innerHTML = `
.content_block, .collapsible-block {
		display: block !important;
}
.section_heading button {
		display: none !important;
}
`;
console.log("boek loaded 2", style)
document.head.appendChild(style)
