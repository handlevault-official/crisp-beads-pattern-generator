    document.addEventListener('keydown',event=>{const mod=event.ctrlKey||event.metaKey;if(mod&&event.key.toLowerCase()==='z'){event.preventDefault();restoreHistory(event.shiftKey?redoStack:undoStack,event.shiftKey?undoStack:redoStack);return}if(mod&&event.key.toLowerCase()==='y'){event.preventDefault();restoreHistory(redoStack,undoStack);return}if(event.key==='Escape'&&animationTimer){clearInterval(animationTimer);animationTimer=null;$('playButton').textContent='▶ Play'}if(!mod&&!event.target.matches('input,select,textarea')){const keys={b:'pencil',e:'eraser',g:'fill',i:'picker'};const next=keys[event.key.toLowerCase()];if(next)document.querySelector(`[data-tool="${next}"]`).click()}});
    renderGallery();
    const autosave = localStorage.getItem(AUTO_KEY);
    if(autosave){
        try{loadProjectObject(JSON.parse(autosave))}catch{newCanvas(32,32)}
    }else{
        newCanvas(32,32);
    }
})();
</script>

<footer>
    <p>&copy; 2026 Crisp Suite / HandleVault Official. All rights reserved.</p>
</footer>

<!-- I-link mo dito ang repo.js -->
<script src="repo.js"></script>

</body>
</html>
