/*
 Copyright (C) 2025 Formez

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.

 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

 Modificata nella funzione _onSourceChange() per la gestione corretta dell'url, v https://github.com/decidim/decidim/issues/13788
*/

export default class AutoSelectOptionsFromUrl {
  constructor(options = {}) {
    this.$source = options.source;
    this.$select = options.select;
    this.sourceToParams = options.sourceToParams;
    this.run();
  }

  run() {
    this.$source.on("change", this._onSourceChange.bind(this));
    this._onSourceChange();
  }

  _onSourceChange() {
    const select = this.$select;
    const params = this.sourceToParams(this.$source);
    // Linea modificata
    const url = this.$source.data("url").split("?")[0]

    $.getJSON(url, params, function (data) {
      select.find("option:not([value=''])").remove();
      const selectedValue = select.data("selected");

      data.forEach((option) => {
        let optionElement = $(`<option value="${option.id}">${option.body}</option>`).appendTo(select);
        if (option.id === selectedValue) {
          optionElement.attr("selected", true);
        }
      });

      if (selectedValue) {
        select.val(selectedValue);
      }
    });
  }
}
