define (require, exports, module) ->
	'''
		<div class="image"><!--Creature picker--></div>

		<div class="options">
			<div class="steps">
				<div data-page="species" class="species active">
					<h4>Objects in this image</h4>

					<ul class="toggles">
						<li><button value="cluster" data-marker="circle">Star Cluster <span class="count">0</button></li>
						<li><button value="galaxy" data-marker="circle">Galaxy <span class="count">0</button></li>
					</ul> 

					<div class="indicator"><!--Marker indicator--></div>

					<div class="other-creatures">
						<h4>Are image artifacts present?</h4>
						<button value="yes">Yes</button>
						<button value="no">No</button>
					</div>
					
					<ul class="toggles" id="artefact-list">
						<li><button value="ghost" data-marker="circle">Ghost <span class="count">0</button></li>
						<li><button value="star" data-marker="axes">Star <span class="count">0</button></li>
						<li><button value="gap" data-marker="axes">Gap <span class="count">0</button></li>
					</ul>

					<button disabled="disabled" class="finished">Done identifying objects</button>
				</div>

				<div class="help">
					<span>Need help?</span>
					<a href="#!/about/data/ground-cover/sand/from-classify" title="Check out the field guide" class="field-guide">Field guide</a>
					<a href="#start-tutorial" title="Go through the tutorial again" class="tutorial-again">Tutorial</a>
				</div>
			</div>

			<div class="summary">
				<p>Thanks!</p>

				<div class="favorite">
					<div class="create"><button>Add to my favorites</button></div>
					<div class="destroy">Favorite added! <button>Undo</button></div>
				</div>

				<div class="talk">
					<p>Would you like to discuss this image in Talk?</p>
					<button value="yes">Yes</button>
					<button value="no">No</button>
				</div>
			</div>
		</div>
	'''
