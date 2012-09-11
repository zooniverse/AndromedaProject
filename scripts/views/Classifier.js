// Generated by CoffeeScript 1.3.3
(function() {

  define(function(require, exports, module) {
    return '<div class="image"><!--Creature picker--></div>\n\n<div class="options">\n	<div class="steps">\n		<div data-page="ground-cover" class="ground-cover active">\n			<h4>Ground covers in this image</h4>\n\n			<ul class="toggles">\n				<!--<li><button value="id">description</button></li>-->\n			</ul>\n\n			<button disabled="disabled" class="finished">Done identifying ground cover</button>\n		</div>\n\n		<div data-page="species" class="species">\n			<h4>Species in this image</h4>\n\n			<ul class="toggles">\n				<li><button value="scallop" data-marker="axes">Scallop <span class="count">0</button></li>\n				<li><button value="fish" data-marker="axes">Fish <span class="count">0</button></li>\n				<li><button value="seastar" data-marker="circle">Seastar <span class="count">0</button></li>\n				<li><button value="crustacean" data-marker="axes">Crustacean <span class="count">0</button></li>\n			</ul>\n\n			<div class="indicator"><!--Marker indicator--></div>\n\n			<div class="other-creatures">\n				<h4>Are there any other species<br />present in this image?</h4>\n				<button value="yes">Yes</button>\n				<button value="no">No</button>\n			</div>\n\n			<button disabled="disabled" class="finished">Done identifying species</button>\n		</div>\n\n		<div class="help">\n			<span>Need help?</span>\n			<a href="#!/about/data/ground-cover/sand/from-classify" title="Check out the field guide" class="field-guide">Field guide</a>\n			<a href="#start-tutorial" title="Go through the tutorial again" class="tutorial-again">Tutorial</a>\n		</div>\n	</div>\n\n	<div class="summary">\n		<p>Thanks!</p>\n		<div class="map-toggle">\n			<div class="thumbnail"><img /></div>\n			<div class="map"><img /></div>\n		</div>\n\n		<div class="information">\n			<div class="latitude">\n				<span class="label">Latitude</span>\n				<span class="value"></span>°</div>\n			<div class="longitude">\n				<span class="label">Longitude</span>\n				<span class="value"></span>°</div>\n			<div class="depth">\n				<span class="label">Depth</span>\n				<span class="value"></span> M</div>\n			<div class="altitude">\n				<span class="label">Altitude</span>\n				<span class="value"></span> M</div>\n			<div class="heading">\n				<span class="label">Heading</span>\n				<span class="value"></span>°</div>\n			<div class="salinity">\n				<span class="label">Salinity</span>\n				<span class="value"></span> PSU</div>\n			<div class="temperature">\n				<span class="label">Temperature</span>\n				<span class="value"></span>° C</div>\n			<div class="speed">\n				<span class="label">Speed</span>\n				<span class="value"></span> kts</div>\n		</div>\n\n		<div class="favorite">\n			<div class="create"><button>Add to my favorites</button></div>\n			<div class="destroy">Favorite added! <button>Undo</button></div>\n		</div>\n\n		<div class="talk">\n			<p>Would you like to discuss this image in Talk?</p>\n			<button value="yes">Yes</button>\n			<button value="no">No</button>\n		</div>\n	</div>\n</div>';
  });

}).call(this);