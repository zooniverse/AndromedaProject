// Generated by CoffeeScript 1.4.0
(function() {

  define(function(require, exports, module) {
    return '<div class="image"><!--Creature picker--></div>\n\n<div class="options">\n	<div class="steps">\n		<div data-page="species" class="species active">\n			<h4>Objects in this image</h4>\n\n			<ul class="toggles">\n				<li><button value="cluster" data-marker="circle">Star Cluster <span class="count">0</button><div class="divider"></div></li>\n				<li><button value="galaxy" data-marker="circle">Galaxy <span class="count">0</button><div class="divider"></div></li>\n			</ul> \n\n			<div class="indicator"><!--Marker indicator--></div>\n			\n			<ul class="toggles" id="artefact-list">\n				<li><button value="ghost" data-marker="circle">Ghost <span class="count">0</button><div class="divider"></div></li>\n				<li><button value="cross" data-marker="axes">Cross <span class="count">0</button><div class="divider"></div></li>\n				<li><button value="linear" data-marker="line">Linear <span class="count">0</button><div class="divider"></div></li>\n			</ul>\n\n			<button class="finished">Finished</button>\n		</div>\n\n		<div class="help">\n			<span>Need help?</span>\n			<a href="#!/guide/from-classify" target="_blank" title="Check out the guide" class="field-guide">Guide</a>\n			<a href="#start-tutorial" title="Go through the tutorial again" class="tutorial-again">Tutorial</a>\n		</div>\n	</div>\n\n	<div class="summary">\n		<p>Thanks!</p>\n        \n        <div class="feedback">\n          <canvas class=\'overlay\'></canvas>\n          <img src=\'images/andromeda_opt.jpg\' />\n        </div>\n        \n		<div class="favorite">\n			<div class="create"><button>Add to my favorites</button></div>\n			<div class="destroy">Favorite added! <button>Undo</button></div>\n			  <button value=\'no\' style=\'width: 100%;margin-top: 20px\'>Continue</button>\n		</div>\n\n	</div>\n</div>';
  });

}).call(this);
