let Application = PIXI.Application,
    Container = PIXI.Container,
    loader = PIXI.loader,
    resources = PIXI.loader.resources,
    TextureCache = PIXI.utils.TextureCache,
    Sprite = PIXI.Sprite;

let app = new Application({ 
    width: 800, 
    height: 600,                       
    antialiasing: true, 
    transparent: false, 
    resolution: 1
  }
);

document.body.appendChild(app.view);