define (require, exports, module) ->
	'''
		<div class="image"><!--Creature picker--></div>

		<div class="options">
			<div class="steps">
				<div data-page="species" class="species active">
					<h4>Objects in this image</h4>

					<ul class="toggles">
						<li><button value="cluster" data-marker="circle">Star Cluster <span class="count">0</button><div class="divider"></div></li>
						<li><button value="galaxy" data-marker="circle">Galaxy <span class="count">0</button><div class="divider"></div></li>
					</ul> 

					<div class="indicator"><!--Marker indicator--></div>
					
					<ul class="toggles" id="artefact-list">
						<li><button value="cross" data-marker="axes">Cross <span class="count">0</button><div class="divider"></div></li>
						<li><button value="linear" data-marker="line">Linear <span class="count">0</button><div class="divider"></div></li>
						<li><button value="ghost" data-marker="circle">Ghost <span class="count">0</button><div class="divider"></div></li>
					</ul>

					<button class="finished">Finished</button>
				</div>

				<div class="help">
					<a href="#!/classify" id="toggleCol" title="Toggle between color and monochrome images" class="toggle-subject">B/W</a>
					<a href="#!/classify" title="Restart this classification" class="reset-subject">Restart</a>
					<a href="#!/classify" title="Show or hide all markings" class="show-hide">Hide</a>
					<a href="#start-tutorial" title="Go through the tutorial again" class="tutorial-again">Tutorial</a>
				</div>
			</div>

			<div class="summary">
				<p>Thanks!</p>
        
        <div class="feedback">
          <div class='box'>
            <span class='key'>ra:</span>
            <span class='value'>---</span>
            <br/>
            <span class='key'>dec:</span>
            <span class='value'>---</span>
          </div>
          <canvas class='overlay'></canvas>
          <img src='images/andromeda_opt.jpg' />
        </div>
        
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
