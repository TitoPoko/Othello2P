

function createGrid(size) {

  console.log("createGrid function is loaded and running (start).");

  const container = document.querySelector('.image-container');
  container.innerHTML = '';
  container.style.gridTemplateColumns = `repeat(${size}, 1fr)`;

  const cellSize = 600 / size;

  for (let i = 1; i <= size * size; i++) {
      const div = document.createElement('div');
      div.className = 'image-box';
      div.style.width = div.style.height = `${cellSize}px`;
      //div.onclick = () => changeImage(i);
      const img = document.createElement('img');
      img.id = `box-image-${i}`;
      img.src = '/images/placeholder_image.jpg';
      img.alt = 'placeholder image';
      div.appendChild(img);
      container.appendChild(div);
  }
}


/*

Javascript code for general game logic and initialization,

Contains functions for setting up the game, managing game state, 
and implementing game rules 
Includes functions for creating the game grid, 
handling game logic, and interacting with the DOM.

Examples: createGrid(), scanLegalMoves(), changeBanner().

already linked to within index.erb

*/