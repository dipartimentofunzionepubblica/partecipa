/* eslint-disable no-ternary, no-plusplus, require-jsdoc */

/*
 Copyright (C) 2025 Formez

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.

 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

 Modificata per inserire la funzione clearInputValues() per la gestione corretta dei valori in caso di cache delle risposte del questionario su Local Storage, v https://github.com/decidim/decidim/issues/13787
*/

class DisplayCondition {
  constructor(options = {}) {
    this.wrapperField = options.wrapperField;
    this.type = options.type;
    this.conditionQuestion = options.conditionQuestion;
    this.answerOption = options.answerOption;
    this.mandatory = options.mandatory;
    this.value = options.value;
    this.onFulfilled = options.onFulfilled;
    this.bindEvent();
  }

  bindEvent() {
    this.checkCondition();
    this.getInputsToListen().on("change", this.checkCondition.bind(this));
  }

  getInputValue() {
    const $conditionWrapperField = $(`.question[data-question-id='${this.conditionQuestion}']`);
    const $textInput = $conditionWrapperField.find("textarea, input[type='text']:not([name$=\\[custom_body\\]])");

    if ($textInput.length) {
      return $textInput.val();
    }

    let multipleInput = [];

    $conditionWrapperField.find(".radio-button-collection, .check-box-collection").find(".collection-input").each((idx, el) => {
      const $input = $(el).find("input[name$=\\[body\\]]");
      const checked = $input.is(":checked");

      if (checked) {
        const text = $(el).find("input[name$=\\[custom_body\\]]").val();
        const value = $input.val();
        const id = $(el).find("input[name$=\\[answer_option_id\\]]").val();

        multipleInput.push({ id, value, text });
      }
    });

    return multipleInput;
  }

  getInputsToListen() {
    const $conditionWrapperField = $(`.question[data-question-id='${this.conditionQuestion}']`);
    const $textInput = $conditionWrapperField.find("textarea, input[type='text']:not([name$=\\[custom_body\\]])");

    if ($textInput.length) {
      return $textInput;
    }

    return $conditionWrapperField.find(".collection-input").find("input:not([type='hidden'])");
  }

  checkAnsweredCondition(value) {
    if (typeof (value) !== "object") {
      return Boolean(value);
    }

    return Boolean(value.some((it) => it.value));
  }

  checkNotAnsweredCondition(value) {
    return !this.checkAnsweredCondition(value);
  }

  checkEqualCondition(value) {
    if (value.length) {
      return value.some((it) => it.id === this.answerOption.toString());
    }
    return false;
  }

  checkNotEqualCondition(value) {
    if (value.length) {
      return value.every((it) => it.id !== this.answerOption.toString());
    }
    return false;
  }

  checkMatchCondition(value) {
    let regexp = new RegExp(this.value, "i");

    if (typeof (value) !== "object") {
      return Boolean(value.match(regexp));
    }

    return value.some(function (it) {
      return it.text
        ? it.text.match(regexp)
        : it.value.match(regexp)
    });
  }

  checkCondition() {
    const value = this.getInputValue();
    let fulfilled = false;

    switch (this.type) {
    case "answered":
      fulfilled = this.checkAnsweredCondition(value);
      break;
    case "not_answered":
      fulfilled = this.checkNotAnsweredCondition(value);
      break;
    case "equal":
      fulfilled = this.checkEqualCondition(value);
      break;
    case "not_equal":
      fulfilled = this.checkNotEqualCondition(value);
      break;
    case "match":
      fulfilled = this.checkMatchCondition(value);
      break;
    default:
      fulfilled = false;
      break;
    }

    this.onFulfilled(fulfilled);
  }
}

class DisplayConditionsComponent {
  constructor(options = {}) {
    this.wrapperField = options.wrapperField;
    this.conditions = {};
    this.showCount = 0;
    this.initializeConditions();
  }

  initializeConditions() {
    const $conditionElements = this.wrapperField.find(".display-condition");

    $conditionElements.each((idx, el) => {
      const $condition = $(el);
      const id = $condition.data("id");
      this.conditions[id] = {};

      this.conditions[id] = new DisplayCondition({
        wrapperField: this.wrapperField,
        type: $condition.data("type"),
        conditionQuestion: $condition.data("condition"),
        answerOption: $condition.data("option"),
        mandatory: $condition.data("mandatory"),
        value: $condition.data("value"),
        onFulfilled: (fulfilled) => {
          this.onFulfilled(id, fulfilled);
        }
      });
    });
  }

  mustShow() {
    const conditions = Object.values(this.conditions);
    const mandatoryConditions = conditions.filter((condition) => condition.mandatory);
    const nonMandatoryConditions = conditions.filter((condition) => !condition.mandatory);

    if (mandatoryConditions.length) {
      return mandatoryConditions.every((condition) => condition.fulfilled);
    }

    return nonMandatoryConditions.some((condition) => condition.fulfilled);

  }

  onFulfilled(id, fulfilled) {
    this.conditions[id].fulfilled = fulfilled;

    if (this.mustShow()) {
      this.showQuestion();
    }
    else {
      this.hideQuestion();
    }
  }

  showQuestion() {
    this.wrapperField.fadeIn();
    this.wrapperField.find("input, textarea").prop("disabled", null);
    this.showCount++;
  }

  hideQuestion() {
    if (this.showCount) {
      this.wrapperField.fadeOut();
    }
    else {
      this.wrapperField.hide();     
    }
  
    this.clearInputValues();
    this.wrapperField.find("input, textarea").prop("disabled", "disabled");    
  }

  clearInputValues() {
  if(this.wrapperField.find("textarea, input[type='text']:not([name$=\\[custom_body\\]])").length) {      
    this.wrapperField.find("textarea, input[type='text']:not([name$=\\[custom_body\\]])").val("");       
    this.wrapperField.find("textarea, input[type='text']:not([name$=\\[custom_body\\]])").change();
  }
      
  if (this.wrapperField.find(".radio-button-collection, .check-box-collection").find(".collection-input")) {
    this.wrapperField.find(".radio-button-collection, .check-box-collection").find(".collection-input").each((idx, el) => {
      
      if($(el).find("input[type=radio][name$=\\[body\\]]").is(":checked")){          
        $(el).find("input[type=radio][name$=\\[body\\]]").prop('checked', false); 
        $(el).find("input[type=radio][name$=\\[body\\]]").change(); 
                                             
      } else if ($(el).find("input[type=checkbox][name$=\\[body\\]]").is(":checked")){                       
        $(el).find("input[type=checkbox][name$=\\[body\\]]").click();
        $(el).find("input[type=checkbox][name$=\\[body\\]]").change();        
      }              
    });
  }
 }

}

export default function createDisplayConditions(options) {
  return new DisplayConditionsComponent(options);
}
