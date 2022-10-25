var Cache = {
  Products: {},
};

function LoadStore(data) {
  $(`.wrapper`).fadeIn();
  $(`#app`).fadeIn();

  SwitchCategory("foods", data);
  $(".tab").removeClass("current");

  $("#foods").addClass("current");
}

function SwitchCategory(category, data) {
  $(`.products`).html(``);

  switch (category) {
    case "foods": {
      Cache.current = "foods";
      Cache.currentItem = data.products["foods"];

      let j;
      for (j = 0; j < data.products["foods"].length; j++) {
        let item = JSON.stringify(data.products["foods"][j]);

        $(`.products`).append(`
        <div class="product" item='${item}'>
          <div class="image">
            <img src="${data.products.foods[j].image}" />
          </div>
          <div class="info">
            <p>${data.products.foods[j].label} <br><small class="price">${data.products.foods[j].price} kr</small></p>
          </div>
          <div class="buy"></div>
        </div>
      `);
      }

      break;
    }

    case "dialtrix": {
      Cache.current = "dialtrix";
      Cache.currentItem = data.products["dialtrix"];

      let j;
      for (j = 0; j < data.products["dialtrix"].length; j++) {
        let item = JSON.stringify(data.products["dialtrix"][j]);
        $(`.products`).append(`
        <div class="product" item='${item}'>
          <div class="image">
            <img src="${data.products.dialtrix[j].image}" />
          </div>
          <div class="info">
            <p>${data.products.dialtrix[j].label} <br><small class="price">${data.products.dialtrix[j].price} kr</small></p>
          </div>
          <div class="buy"></div>
        </div>
      `);
      }
      break;
    }

    case "tobak": {
      Cache.current = "tobak";
      Cache.currentItem = data.products["tobak"];

      let j;
      for (j = 0; j < data.products["tobak"].length; j++) {
        let item = JSON.stringify(data.products["tobak"][j]);
        $(`.products`).append(`
        <div class="product" item='${item}'>
          <div class="image">
            <img src="${data.products.tobak[j].image}" />
          </div>
          <div class="info">
            <p>${data.products.tobak[j].label} <br><small class="price">${data.products.tobak[j].price} kr</small></p>
          </div>
          <div class="buy"></div>
        </div>
      `);
      }
      break;
    }

    case "drinks": {
      Cache.current = "drinks";
      Cache.currentItem = data.products["drinks"];

      let j;
      for (j = 0; j < data.products["drinks"].length; j++) {
        let item = JSON.stringify(data.products["drinks"][j]);
        $(`.products`).append(`
        <div class="product" item='${item}'>
          <div class="image">
            <img src="${data.products.drinks[j].image}" />
          </div>
          <div class="info">
            <p>${data.products.drinks[j].label} <br><small class="price">${data.products.drinks[j].price} kr</small></p>
          </div>
          <div class="buy"></div>
        </div>
      `);
      }
      break;
    }

    case "freeze": {
      Cache.current = "freeze";
      Cache.currentItem = data.products["freeze"];

      let j;
      for (j = 0; j < data.products["freeze"].length; j++) {
        let item = JSON.stringify(data.products["freeze"][j]);

        $(`.products`).append(`
        <div class="product" item='${item}'>
          <div class="image">
            <img src="${data.products.freeze[j].image}" />
          </div>
          <div class="info">
            <p>${data.products.freeze[j].label} <br><small class="price">${data.products.freeze[j].price} kr</small></p>
          </div>

          <div class="buy"></div>
        </div>
      `);
      }
      break;
    }
  }
}

function PostMessage(event, data) {
  $.post(
    "https://altrix_stores/eventHandler",
    JSON.stringify({
      event: event,
      data: data || {},
    })
  );
}

function HideStore() {
  $(`.wrapper`).hide();
  $(`#app`).hide();
  PostMessage("close");
}

window.addEventListener("message", function (event) {
  let data = event.data;

  Cache.Products = data.data.products;

  switch (data.evt) {
    case "show": {
      LoadStore(data.data);
      break;
    }
  }

  $(document).on("click", "#close", function (e) {
    $(".products").removeClass("blur");
    $(".categories").removeClass("blur");

    $(".buy-modal").hide();
  });

  $(document).on("click", ".tab", function (event) {
    $(".tab").removeClass("current");

    $(this).addClass("current");
    SwitchCategory(event["currentTarget"]["id"], data.data);
  });

  document.onkeydown = function (event) {
    if (event.which === 27) {
      HideStore();
    }
  };
});

// opening the modal
$(document).on("click", ".product", function (e) {
  let newc = $(e.currentTarget).attr("item");
  $(".buy-modal").attr("id", newc);
  $(".products").addClass("blur");
  $(".categories").addClass("blur");

  $(".buy-modal").show();

  let data = JSON.parse($(e.currentTarget).attr("item"));
  $(".buy-modal .info .item").html(
    `<div>
        <small>Föremål<br></small><p>${data.label}</p>
        <small>Pris<br></small><p class="price">${data.price} kr</p>
      </div>

      <div class="image">

        <img src="${data.image}">

      </div>
      `
  );
});

$(document).on("click", ".buy-modal div .buy", function (e) {
  // parsing the json object attribute
  let item = JSON.parse(
    $(e.currentTarget).parent().parent().parent().attr("id")
  );
  // sending the item to the lua
  PostMessage("buyItems", {
    price: parseInt(item.price),
    item: item,
  });
});
