const display = () => {
  const RightIcon = document.querySelectorAll(".right-content-icon");
  const RightList = document.querySelectorAll("#list");
  const OtherElement = document.querySelectorAll(":not(.right-content-icon)")

  RightIcon.forEach(function(icon){
    icon.addEventListener("mouseover", () => {
      document.body.style.cursor = "pointer";
    });

    icon.addEventListener("mouseout", () => {
      document.body.style.cursor = "default";
    });
  
  });

  window.addEventListener("click", (e) => {
    if (e.target.className != "right-content-icon"){
      RightList.forEach(function(list){
        list.removeAttribute("style", "display: block;");
      });
    };
  });

  for(let i = 0; i < RightIcon.length; i ++ ){
    RightIcon[i].addEventListener("click", () => {
      RightList.forEach(function(list){
        if (list.getAttribute("style") == "display: block;"){
          list.removeAttribute("style", "display: block;");
        };
      });
      if (RightList[i].getAttribute("style") == "display: block;"){
        RightList[i].removeAttribute("style", "display: block;");
      } else {
        RightList[i].setAttribute("style", "display: block;");
      };
    });
  };


};

window.addEventListener("load", display);