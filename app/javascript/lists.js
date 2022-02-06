const display = () => {
  const RightIcon = document.querySelectorAll(".right-content-icon");
  const RightList = document.querySelectorAll("#list");

  RightIcon.forEach(function(icon){
    icon.addEventListener("mouseover", () => {
      document.body.style.cursor = "pointer";
    });

    icon.addEventListener("mouseout", () => {
      document.body.style.cursor = "default";
    });
  
  });

  for(let i = 0; i < RightIcon.length; i ++ ){
    RightIcon[i].addEventListener("click", () => {
      if (RightList[i].getAttribute("style") == "display: block;"){
        RightList[i].removeAttribute("style", "display: block;");
      } else {
        RightList[i].setAttribute("style", "display: block;");
      };
    });
  };

  // window.addEventListener("click", () => {
  //   RightList.forEach(function(list){
  //     if (list.getAttribute("style") == "display: block;"){
  //       // list.removeAttribute("style", "display: block;");
  //       console.log("blockがありました");
  //     };
  //   });
  // });
};

window.addEventListener("load", display);