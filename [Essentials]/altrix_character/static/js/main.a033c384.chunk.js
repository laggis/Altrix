(window.webpackJsonp = window.webpackJsonp || []).push([
  [0],
  {
    11: function (e, t, a) {
      e.exports = a.p + "static/media/revoked.3a55e3b4.png";
    },
    15: function (e, t, a) {
      e.exports = a(26);
    },
    21: function (e, t, a) {},
    26: function (e, t, a) {
      "use strict";
      a.r(t);
      var n = a(0),
        c = a.n(n),
        r = a(7),
        o = a.n(r),
        i = (a(21), a(1)),
        s = a(2),
        l = a(4),
        m = a(3),
        h = a(5),
        u = a(11),
        d = a.n(u),
        p = a(27),
        f = (function (e) {
          function t() {
            var e, a;
            Object(i.a)(this, t);
            for (var n = arguments.length, c = new Array(n), r = 0; r < n; r++)
              c[r] = arguments[r];
            return (
              ((a = Object(l.a)(
                this,
                (e = Object(m.a)(t)).call.apply(e, [this].concat(c))
              )).state = {
                positions: [
                  { label: "Senaste Position", action: "last", selected: !1 },
                  { label: "Torget", action: "torget", selected: !1 },
                  { label: "Piren", action: "piren", selected: !1 }, 
                  { label: "Arbetsplats", action: "job", selected: !1 },
                ],
                onPlay: !1,
              }),
              (a.emitEvent = function (e, t) {
                var a = {
                  method: "POST",
                  body: JSON.stringify({ event: e, data: t }),
                };
                console.log(
                  "Sending event to client: "
                    .concat(e, " with data: ")
                    .concat(JSON.stringify(t))
                ),
                  fetch("http://nuipipe/nui_client_response", a);
              }),
              (a.handlePlay = function () {
                var e = null;
                a.state.positions.forEach(function (t) {
                  t.selected && (e = t.action);
                }),
                  e &&
                    (a.emitEvent("esx:choosePlayer", {
                      id: a.props.activeChar.id,
                      position: e,
                    }),
                    a.setState({ onPlay: !0 }),
                    a.props.onClose());
              }),
              (a.onChoosePositionBack = function () {
                a.props.onChoosePositionBack(),
                  setTimeout(function () {
                    for (var e = a.state.positions, t = 0; t < e.length; t++)
                      e[t].selected = !1;
                    a.setState({ positions: e });
                  }, 500);
              }),
              (a.handleSelected = function (e) {
                for (var t = a.state.positions, n = 0; n < t.length; n++)
                  t[n].selected = e === n;
                a.setState({ positions: t });
              }),
              (a.checkIfSelected = function () {
                for (
                  var e = a.state.positions, t = [], n = 0;
                  n < e.length;
                  n++
                )
                  e[n].selected && t.push(["test"]);
                return !!t.length;
              }),
              a
            );
          }
          return (
            Object(h.a)(t, e),
            Object(s.a)(t, [
              {
                key: "render",
                value: function () {
                  var e = this,
                    t = !1;
                  "characterChoosePosition" === this.props.currentApp &&
                    (t = !0);
                  var a = "character-choose-overlay";
                  return (
                    this.state.onPlay && (a += " playing"),
                    c.a.createElement(
                      p.a,
                      {
                        appear: !0,
                        leave: !t,
                        in: t,
                        unmountOnExit: !0,
                        classNames: "character-selection-animation",
                        timeout: 500,
                      },
                      c.a.createElement(
                        "div",
                        { className: a },
                        c.a.createElement(
                          "div",
                          {
                            onClick: function () {
                              return e.onChoosePositionBack();
                            },
                            className: "character-choose-position-back",
                          },
                          "Tillbaka"
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-position-header" },
                          "Vart vill du spawna"
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-positions-container" },
                          this.state.positions.map(function (t, a) {
                            var n = t.selected ? "selected" : "";
                            return c.a.createElement(
                              p.a,
                              {
                                in: !0,
                                appear: !0,
                                enter: !0,
                                classNames:
                                  "character-choose-position-animation",
                                timeout: 700,
                              },
                              c.a.createElement(
                                "div",
                                {
                                  key: a,
                                  onClick: function () {
                                    return e.handleSelected(a);
                                  },
                                  className: "character-choose-position ".concat(
                                    n
                                  ),
                                },
                                c.a.createElement(
                                  "div",
                                  {
                                    className: "character-choose-positon-label",
                                  },
                                  t.label
                                )
                              )
                            );
                          })
                        ),
                        this.checkIfSelected()
                          ? c.a.createElement(
                              p.a,
                              {
                                in: !0,
                                appear: !0,
                                classNames: "character-box-animation",
                                timeout: 500,
                              },
                              c.a.createElement(
                                "button",
                                {
                                  className: "character-choose-position-btn",
                                  onClick: this.handlePlay,
                                },
                                `Spawna`
                              )
                            )
                          : ""
                      )
                    )
                  );
                },
              },
            ]),
            t
          );
        })(n.Component),
        v = (function (e) {
          function t(e) {
            var a;
            return (
              Object(i.a)(this, t),
              ((a = Object(l.a)(
                this,
                Object(m.a)(t).call(this, e)
              )).emitEvent = function (e, t) {
                var a = {
                  method: "POST",
                  body: JSON.stringify({ event: e, data: t }),
                };
                console.log(
                  "Sending event to client: "
                    .concat(e, " with data: ")
                    .concat(JSON.stringify(t))
                ),
                  fetch("http://nuipipe/nui_client_response", a);
              }),
              (a.onCreateCharacter = function () {
                a.state.validated &&
                  (a.emitEvent("esx:createCharacter", {
                    firstname: a.state.name,
                    lastname: a.state.lastname,
                    sex: a.state.gender,
                    dateofbirth: a.state.dob,
                  }),
                  a.setState({ onPlay: !0 }),
                  a.props.onClose());
              }),
              (a.onCreateCharacterBack = function () {
                a.props.onCreateCharacterBack();
              }),
              (a.handleOnChange = function (e, t) {
                var n = [0, 1, 2, 3, 5, 6, 8, 9],
                  c = e.target.value;
                switch (t) {
                  case "name":
                    a.setState({ name: c });
                    break;
                  case "lastname":
                    a.setState({ lastname: c });
                    break;
                  case "gender":
                    a.setState({ gender: c.toUpperCase() });
                    break;
                  case "dob":
                    a.setState({ dob: c });
                }
                setTimeout(function () {
                  !(function () {
                    var e = !0,
                      t = a.state.dob;
                    t.length > 10 && (e = !1),
                      t[4] ? "-" !== t[4] && (e = !1) : (e = !1),
                      t[7] ? "-" !== t[7] && (e = !1) : (e = !1),
                      10 !== t.length && (e = !1),
                      n.forEach(function (a, n) {
                        t[a] && isNaN(t[a]) && (e = !1);
                      }),
                      a.state.name.length <= 0 && (e = !1),
                      a.state.lastname.length <= 0 && (e = !1),
                      1 !== a.state.gender.length && (e = !1),
                      a.setState({ validated: e });
                  })();
                }, 1);
              }),
              (a.state = {
                name: "",
                lastname: "",
                dob: "",
                gender: "",
                validated: !1,
                onPlay: !1,
              }),
              a
            );
          }
          return (
            Object(h.a)(t, e),
            Object(s.a)(t, [
              {
                key: "render",
                value: function () {
                  var e = this,
                    t = !1,
                    a = this.state.validated ? "good" : "disabled";
                  "characterCreate" === this.props.currentApp && (t = !0);
                  var n = "character-create-overlay";
                  return (
                    this.state.onPlay && (n += " playing"),
                    c.a.createElement(
                      p.a,
                      {
                        timeout: 500,
                        classNames: "character-selection-animation",
                        appear: !0,
                        leave: !t,
                        in: t,
                        unmountOnExit: !0,
                      },
                      c.a.createElement(
                        "div",
                        { className: n },
                        c.a.createElement(
                          "button",
                          {
                            onClick: function () {
                              return e.onCreateCharacterBack();
                            },
                            className: "character-create-back",
                          },
                          "Tillbaka"
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-create-container" },
                          c.a.createElement(
                            "div",
                            { className: "header" },
                            "Skapa din karakt\xe4r"
                          ),
                          c.a.createElement(
                            "div",
                            { className: "input-container" },
                            c.a.createElement("input", {
                              value: this.state.name,
                              onChange: function (t) {
                                return e.handleOnChange(t, "name");
                              },
                              spellcheck: "false",
                              type: "text",
                              placeholder: "Namn",
                            }),
                            c.a.createElement("input", {
                              value: this.state.lastname,
                              onChange: function (t) {
                                return e.handleOnChange(t, "lastname");
                              },
                              spellcheck: "false",
                              type: "text",
                              placeholder: "Efternamn",
                            }),
                            c.a.createElement("input", {
                              value: this.state.gender,
                              onChange: function (t) {
                                return e.handleOnChange(t, "gender");
                              },
                              spellcheck: "false",
                              type: "text",
                              placeholder: "K\xf6n (M/F)",
                            }),
                            c.a.createElement("input", {
                              value: this.state.dob,
                              onChange: function (t) {
                                return e.handleOnChange(t, "dob");
                              },
                              spellcheck: "false",
                              type: "text",
                              placeholder:
                                "F\xf6ddelsedatum (\xc5\xc5\xc5\xc5-MM-DD)",
                            }),
                            c.a.createElement(
                              "button",
                              { onClick: this.onCreateCharacter, className: a },
                              "Skapa"
                            )
                          )
                        )
                      )
                    )
                  );
                },
              },
            ]),
            t
          );
        })(n.Component),
        b = a(9),
        C = a.n(b),
        E = (function (e) {
          function t() {
            var e, a;
            Object(i.a)(this, t);
            for (var n = arguments.length, c = new Array(n), r = 0; r < n; r++)
              c[r] = arguments[r];
            return (
              ((a = Object(l.a)(
                this,
                (e = Object(m.a)(t)).call.apply(e, [this].concat(c))
              )).onCharacterPlay = function () {
                a.props.handleCharacterPlay(a.props.ir);
              }),
              a
            );
          }
          return (
            Object(h.a)(t, e),
            Object(s.a)(t, [
              {
                key: "render",
                value: function () {
                  var e = this.props.data,
                    t = e.firstname,
                    a = e.lastname,
                    n = e.id,
                    r = e.job,
                    o = e.job_grade,
                    i = e.phonenumber,
                    s = e.cash,
                    l = e.bank;
                  return c.a.createElement(
                    p.a,
                    {
                      in: !0,
                      appear: !0,
                      enter: !0,
                      classNames: "character-box-animation",
                      timeout: 500,
                    },
                    c.a.createElement(
                      "div",
                      { className: "character-box", style: { width: 230 } },
                      c.a.createElement(
                        "div",
                        { className: "content" },
                        c.a.createElement("h2", null, "0", this.props.ir + 1),
                        c.a.createElement(
                          "h3",
                          { className: "character-box-h" },
                          t,
                          " ",
                          a
                        ),
                        c.a.createElement("hr", null),
                        c.a.createElement(
                          "div",
                          { className: "character-box-label" },
                          "Personummer: ",
                          n
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-box-label" },
                          "Jobb: ",
                          r,
                          " - ",
                          o
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-box-label" },
                          "Telefonnummer: ",
                          i
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-box-label" },
                          "Kontanter: ",
                          c.a.createElement(C.a, {
                            quantity: s,
                            currency: "SEK",
                          })
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-box-label" },
                          "Bank: ",
                          c.a.createElement(C.a, {
                            quantity: l,
                            currency: "SEK",
                          })
                        ),
                        c.a.createElement(
                          "div",
                          { className: "character-box-actions" },
                          c.a.createElement(
                            "button",
                            {
                              onClick: this.onCharacterPlay,
                              className: "character-box-action sucsess",
                            },
                            "Spela"
                          ),
                          c.a.createElement(
                            "button",
                            {
                              onClick: this.props.onCharacterRemove,
                              className: "character-box-action danger",
                            },
                            "Ta bort"
                          )
                        )
                      )
                    )
                  );
                },
              },
            ]),
            t
          );
        })(n.Component),
        k = (function (e) {
          function t(e) {
            var a;
            return (
              Object(i.a)(this, t),
              ((a = Object(l.a)(
                this,
                Object(m.a)(t).call(this, e)
              )).handleClick = function () {
                a.props.onCreateCharacter();
              }),
              (a.state = {}),
              a
            );
          }
          return (
            Object(h.a)(t, e),
            Object(s.a)(t, [
              {
                key: "render",
                value: function () {
                  return c.a.createElement(
                    p.a,
                    {
                      in: !0,
                      appear: !0,
                      enter: !0,
                      classNames: "character-box-animation",
                      timeout: 500,
                    },
                    c.a.createElement(
                      "div",
                      { className: "character-box", style: { width: 230 } },
                      c.a.createElement(
                        "div",
                        { className: "content" },
                        c.a.createElement("h2", null, "0", this.props.ir),
                        c.a.createElement(
                          "h3",
                          { className: "character-box-h" },
                          "Skapa Karakt\xe4r"
                        ),
                        c.a.createElement("hr", null),
                        c.a.createElement(
                          "button",
                          {
                            onClick: this.handleClick,
                            className: "character-box-action revoked",
                          },
                          "Skapa"
                        )
                      )
                    )
                  );
                },
              },
            ]),
            t
          );
        })(n.Component),
        y = (function (e) {
          function t(e) {
            var a;
            return (
              Object(i.a)(this, t),
              ((a = Object(l.a)(
                this,
                Object(m.a)(t).call(this, e)
              )).emitEvent = function (e, t) {
                var a = {
                  method: "POST",
                  body: JSON.stringify({ event: e, data: t }),
                };
                console.log(
                  "Sending event to client: "
                    .concat(e, " with data: ")
                    .concat(JSON.stringify(t))
                ),
                  fetch("http://nuipipe/nui_client_response", a);
              }),
              (a.handleMessage = function (e) {
                var t = e.data;
                switch (t.type) {
                  case "OPEN":
                    a.setState({ characters: t.characters, open: !0 });
                    break;
                  case "CLOSE":
                    a.handleClose();
                }
              }),
              (a.handleClose = function () {
                a.setState({
                  characters: [],
                  open: !1,
                  selected: null,
                  currentApp: "characterSelection",
                  activeCharacter: null,
                  removeCharacter: null,
                });
              }),
              (a.handleCharacterRemove = function (e) {
                var t = a.state.comfirmBox;
                (t.visible = !0),
                  (t.info.header = "Bekr\xe4fta"),
                  (t.info.content =
                    "Vill du verkligen ta bort din karakt\xe4r"),
                  (t.info.comfirm = "Ta bort"),
                  (t.info.cancel = "Avbryt"),
                  (t.action = "REMOVE_CHARACTER"),
                  a.setState({ comfirmBox: t, removeCharacter: e });
              }),
              (a.handleCharacterPlay = function (e) {
                a.setState({ currentApp: "characterChoosePosition" }),
                  a.setState({ activeCharacter: a.state.characters[e] });
              }),
              (a.handleChoosePositionBack = function () {
                a.setState({ currentApp: "characterSelection" });
              }),
              (a.onComfirmBoxComfirm = function (e) {
                switch (e) {
                  case "REMOVE_CHARACTER":
                    var t = a.state.removeCharacter,
                      n = a.state.characters,
                      c = n.indexOf(t);
                    n.splice(c, 1),
                      a.setState({ characters: n, removeCharacter: "" }),
                      a.emitEvent("esx:deleteCharacter", {
                        id: a.state.removeCharacter.id,
                      });
                }
                var r = a.state.comfirmBox;
                (r.visible = !1),
                  a.setState({ comfirmBox: r }, function () {
                    setTimeout(function () {
                      (r.info.header = ""),
                        (r.info.content = ""),
                        (r.info.comfirm = ""),
                        (r.info.cancel = ""),
                        (r.action = ""),
                        a.setState({ comfirmBox: r });
                    }, 500);
                  });
              }),
              (a.onComfirmBoxCancel = function (e) {
                var t = a.state.comfirmBox;
                (t.visible = !1),
                  a.setState({ comfirmBox: t }, function () {
                    setTimeout(function () {
                      (t.info.header = ""),
                        (t.info.content = ""),
                        (t.info.comfirm = ""),
                        (t.info.cancel = ""),
                        (t.action = ""),
                        a.setState({ comfirmBox: t });
                    }, 500);
                  });
              }),
              (a.onCharacterCreateBack = function () {
                a.setState({ currentApp: "characterSelection" });
              }),
              (a.handleCreateCharacter = function () {
                a.setState({ currentApp: "characterCreate" });
              }),
              (a.state = {
                open: !1,
                characters: [],
                selected: null,
                currentApp: "characterSelection",
                activeCharacter: null,
                removeCharacter: null,
                comfirmBox: {
                  visible: !1,
                  info: { header: "", content: "", comfirm: "", cancel: "" },
                },
              }),
              a
            );
          }
          return (
            Object(h.a)(t, e),
            Object(s.a)(t, [
              {
                key: "componentDidMount",
                value: function () {
                  window.addEventListener("message", this.handleMessage);
                },
              },
              {
                key: "render",
                value: function () {
                  var e = this,
                    t = !1,
                    a = { zIndex: 0 };
                  "characterSelection" === this.state.currentApp && (t = !0),
                    this.state.comfirmBox.visible && (a = { zIndex: 999999 });
                  var n = this.state.characters,
                    r = 4 - n.length;
                  return c.a.createElement(
                    p.a,
                    {
                      timeout: 500,
                      classNames: "character-selection-animation",
                      appear: !0,
                      leave: !this.state.open,
                      in: this.state.open,
                      unmountOnExit: !0,
                    },
                    c.a.createElement(
                      "div",
                      { className: "overlay" },
                      c.a.createElement(
                        "div",
                        { className: "overlay-inner" },
                        c.a.createElement(
                          p.a,
                          {
                            timeout: 700,
                            classNames: "character-comfirm-box-animation",
                            appear: !0,
                            leave: !this.state.comfirmBox.visible,
                            in: this.state.comfirmBox.visible,
                            unmountOnExit: !0,
                          },
                          c.a.createElement(
                            "div",
                            {
                              className: "character-selection-overlay",
                              style: a,
                            },
                            c.a.createElement(
                              "div",
                              {
                                className:
                                  "character-selection-comfirm-container",
                              },
                              c.a.createElement(
                                "div",
                                { className: "header" },
                                this.state.comfirmBox.info.header
                              ),
                              c.a.createElement(
                                "div",
                                { className: "content" },
                                this.state.comfirmBox.info.content
                              ),
                              c.a.createElement(
                                "div",
                                { className: "buttons" },
                                c.a.createElement(
                                  "button",
                                  {
                                    onClick: function () {
                                      return e.onComfirmBoxCancel(
                                        e.state.comfirmBox.action
                                      );
                                    },
                                    className: "button-cancel",
                                  },
                                  this.state.comfirmBox.info.cancel
                                ),
                                c.a.createElement(
                                  "button",
                                  {
                                    onClick: function () {
                                      return e.onComfirmBoxComfirm(
                                        e.state.comfirmBox.action
                                      );
                                    },
                                    className: "button-comfirm",
                                  },
                                  this.state.comfirmBox.info.comfirm
                                )
                              )
                            )
                          )
                        ),
                        c.a.createElement(
                          p.a,
                          {
                            timeout: 500,
                            classNames: "character-selection-animation",
                            appear: !0,
                            leave: !t,
                            in: t,
                            unmountOnExit: !0,
                          },
                          c.a.createElement(
                            "div",
                            { className: "character-box-select-overlay" },
                            c.a.createElement(
                              "div",
                              { className: "character-box-logo" },
                              c.a.createElement("img", {
                                height: "350px",
                                src: d.a,
                                alt: "",
                              })
                            ),
                            c.a.createElement(
                              "div",
                              { className: "character-box-container" },
                              n.map(function (t, a) {
                                return c.a.createElement(E, {
                                  onClose: e.handleClose,
                                  onCharacterRemove: function () {
                                    return e.handleCharacterRemove(t);
                                  },
                                  handleCharacterPlay: function () {
                                    return e.handleCharacterPlay(a);
                                  },
                                  key: a,
                                  data: t,
                                  ir: a,
                                });
                              }),
                              Array.apply(null, { length: r }).map(function (
                                t,
                                a
                              ) {
                                return c.a.createElement(k, {
                                  isSelected: !1,
                                  key: a,
                                  onCreateCharacter: e.handleCreateCharacter,
                                  ir: n.length + a + 1,
                                });
                              })
                            )
                          )
                        ),
                        c.a.createElement(f, {
                          onClose: this.handleClose,
                          currentApp: this.state.currentApp,
                          activeChar: this.state.activeCharacter,
                          onChoosePositionBack: this.handleChoosePositionBack,
                        }),
                        c.a.createElement(v, {
                          onClose: this.handleClose,
                          onCreateCharacterBack: this.onCharacterCreateBack,
                          currentApp: this.state.currentApp,
                        })
                      )
                    )
                  );
                },
              },
            ]),
            t
          );
        })(n.Component);
      var g = function () {
        return c.a.createElement(
          "div",
          { className: "App" },
          c.a.createElement(y, null)
        );
      };
      Boolean(
        "localhost" === window.location.hostname ||
          "[::1]" === window.location.hostname ||
          window.location.hostname.match(
            /^127(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$/
          )
      );
      o.a.render(c.a.createElement(g, null), document.getElementById("root")),
        "serviceWorker" in navigator &&
          navigator.serviceWorker.ready.then(function (e) {
            e.unregister();
          });
    },
  },
  [[15, 1, 2]],
]);
//# sourceMappingURL=main.a033c384.chunk.js.map
