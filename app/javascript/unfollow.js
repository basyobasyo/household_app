const unfollow = () => {
  const pairName = document.getElementById("pair-nickname");
  const hidden = document.querySelector(".hidden")

  pairName.addEventListener("mouseover", () => {
    pairName.setAttribute("style", "cursor: pointer;");
  });

  pairName.addEventListener("mouseout", () => {
    pairName.removeAttribute("style", "cursor: default;");
  });

  window.addEventListener("click", (e) => {
    if (e.target.id != "pair-nickname"){
      if (hidden.getAttribute("style") == "display: block;"){
        hidden.removeAttribute("style", "display: block");
      }
    }
  });

  pairName.addEventListener("click", () => {
    if (hidden.getAttribute("style") == "display: block;"){
      hidden.removeAttribute("style", "display: block");
    } else {
      hidden.setAttribute("style", "display: block;");
    }
  });
};

window.addEventListener("load", unfollow);