/*
 Copyright (C) 2026 Formez

 This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, version 3.

 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>

 Modificata per eliminare il controllo sul check della newsletter eliminato nel form
*/

import PasswordToggler from "src/decidim/password_toggler";

$(() => {
  const $userRegistrationForm = $("#register-form");
  const $userGroupFields      = $userRegistrationForm.find(".user-group-fields");
  const userPassword         =  document.querySelector(".user-password");
  const inputSelector         = 'input[name="user[sign_up_as]"]';
  const newsletterSelector    = 'input[type="checkbox"][name="user[newsletter]"]';
  const $newsletterModal      = $("#sign-up-newsletter-modal");


  const setGroupFieldsVisibility = (value) => {
    if (value === "user") {
      $userGroupFields.hide();
    } else {
      $userGroupFields.show();
    }
  }

  const checkNewsletter = (check) => {
    $userRegistrationForm.find(newsletterSelector).prop("checked", check);
    $newsletterModal.data("continue", true);
    window.Decidim.currentDialogs["sign-up-newsletter-modal"].close()
    $userRegistrationForm.submit();
  }

  setGroupFieldsVisibility($userRegistrationForm.find(`${inputSelector}:checked`).val());

  $userRegistrationForm.on("change", inputSelector, (event) => {
    const value = event.target.value;

    setGroupFieldsVisibility(value);
  });

  $newsletterModal.find("[data-check]").on("click", (event) => {
    checkNewsletter($(event.target).data("check"));
  });

  if (userPassword) {
    new PasswordToggler(userPassword).init();
  }
});
