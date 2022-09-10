// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// bank address
  internal static var rrmBankAddress: String { return L10n.tr("Localizable", "rrm_bank_address") }
  /// bank Contact information
  internal static var rrmBankContactInfo: String { return L10n.tr("Localizable", "rrm_bank_contact_info") }
  /// title combined disclosure error resolution
  internal static var rrmCombinedDisclosureErrorResolution: String { return L10n.tr("Localizable", "rrm_combined_disclosure_error_resolution") }
  /// You have the right text
  internal static var rrmYouHaveTheRight: String { return L10n.tr("Localizable", "rrm_you_have_the_right") }
  /// You can cancel text
  internal static var rrmYouCanCancel: String { return L10n.tr("Localizable", "rrm_you_can_cancel") }
  /// Questions or complaints
  internal static var rrmForQuestionsOrComplaints: String { return L10n.tr("Localizable", "rrm_for_questions_or_complaints") }
  /// Cancel
  internal static var rrmCancelButton: String { return L10n.tr("Localizable","rrm_cancel_button") }
  internal static var rrmContinueButton: String { return L10n.tr("Localizable","rrm_continue_button") }
  internal static var rrmDoneButton: String { return L10n.tr("Localizable","rrm_done_button") }
  internal static var rrmDropdownPlaceholder: String { return L10n.tr("Localizable","rrm_dropdown_placeholder") }
  internal static var rrmConfirmationNumberLabel: String { return L10n.tr("Localizable","rrm_confirmation_number_label") }
  internal static var rrmConfirmationScreenTitle: String { return L10n.tr("Localizable","rrm_confirmation_screen_title") }
  internal static func rrmTransSubmittedDetailsMessage(_ p1: Any, _ p2: Any, _ p3: Any, _ p4: Any, _ p5: Any) -> String {
    return L10n.tr("Localizable", "rrm_trans_submitted_details_message", String(describing: p1), String(describing: p2), String(describing: p3), String(describing: p4), String(describing: p5))
  }
  internal static var rrmTransSubmittedTitle: String { return L10n.tr("Localizable","rrm_trans_submitted_title") }
  internal static var rrmFraudWarningContent: String { return L10n.tr("Localizable","rrm_fraud_warning_content") }
  internal static var rrmNextRecipientBankdetailsButton: String { return L10n.tr("Localizable","rrm_next_recipient_bankdetails_button") }
  internal static var rrmRecipientDetailsHeader: String { return L10n.tr("Localizable","rrm_recipient_details_header") }
  internal static var rrmRecipientDetailsReviewDisclaimer: String { return L10n.tr("Localizable","rrm_recipient_details_review_disclaimer") }
  internal static var rrmRecipientDetailsScreenTitle: String { return L10n.tr("Localizable","rrm_recipient_details_screen_title") }
  internal static var rrmFraudWarningTitle: String { return L10n.tr("Localizable","rrm_fraud_warning_title") }
  internal static var rrmRecipientBankDetailsScreenTitle: String { return L10n.tr("Localizable","rrm_recipient_bank_details_screen_title") }
  internal static var rrmRecipientsBankDetailsHeader: String { return L10n.tr("Localizable","rrm_recipients_bank_details_header") }
  internal static var rrmAddNewButton: String { return L10n.tr("Localizable","rrm_add_new_button") }
  internal static var rrmBankTransfer: String { return L10n.tr("Localizable","rrm_bank_transfer") }
  internal static var rrmRecipientsListTitle: String { return L10n.tr("Localizable","rrm_recipients_list_title") }
  internal static var rrmSendMoneyButton: String { return L10n.tr("Localizable","rrm_send_money_button") }
  internal static var rrmAlmostThereText: String { return L10n.tr("Localizable","rrm_almost_there_text") }
  internal static var rrmAlmostThereTitle: String { return L10n.tr("Localizable","rrm_almost_there_title") }
  internal static var rrmCompleteTransferButton: String { return L10n.tr("Localizable","rrm_complete_transfer_button") }
  internal static var rrmNextReviewButton: String { return L10n.tr("Localizable","rrm_next_review_button") }
  internal static var rrmPrivacyTermsofuseDisclaimer: String { return L10n.tr("Localizable","rrm_privacy_termsofuse_disclaimer") }
  internal static var rrmRecipientAccountDetailsreviewdisclaimer: String { return L10n.tr("Localizable","rrm_recipient_account_detailsReviewDisclaimer") }
  internal static var rrmReviewPageTitle: String { return L10n.tr("Localizable","rrm_review_page_title") }
  internal static var rrmViewReceiptLink: String { return L10n.tr("Localizable","rrm_view_receipt_link") }
  
  internal static func rrmSlaDisclaimerText(_ p1: Any) -> String {
    return L10n.tr("Localizable", "rrm_sla_disclaimer_text", String(describing: p1))
  }
  
  internal static func rrmSlaDisclaimerTextWithName(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "rrm_sla_disclaimer_text_with_name", String(describing: p1), String(describing: p2))
  }
  internal static var rrmBankTransferScreenTitle: String { return L10n.tr("Localizable","rrm_bank_transfer_screen_title") }
  internal static var rrmDestinationCountry: String { return L10n.tr("Localizable","rrm_destination_country") }
  internal static var rrmExchangeRate: String { return L10n.tr("Localizable","rrm_exchange_rate") }
  internal static var rrmReceiveAmount: String { return L10n.tr("Localizable","rrm_receive_amount") }
  internal static var rrmSendAmount: String { return L10n.tr("Localizable","rrm_send_amount") }
  internal static var rrmTotalCost: String { return L10n.tr("Localizable","rrm_total_cost") }
  internal static var rrmTransferDetails: String { return L10n.tr("Localizable","rrm_transfer_details") }
  internal static var rrmTransferFee: String { return L10n.tr("Localizable","rrm_transfer_fee") }
  internal static var rrmTransferType: String { return L10n.tr("Localizable","rrm_transfer_type") }
  internal static var rrmNoRecipients: String { return L10n.tr("Localizable", "rrm_no_recipients") }
  internal static var rrmEditButton: String { return L10n.tr("Localizable", "rrm_edit_button") }
  internal static var rrmRecipientType: String { return L10n.tr("Localizable", "rrm_recipient_type") }
  internal static var rrmTransferConfirmationTitle: String { return L10n.tr("Localizable", "rrm_transfer_confirmation_title") }
  internal static var rrmCommonSearchType: String { return L10n.tr("Localizable", "rrm_common_search_type") }
  internal static func rrmErrorEmptyDynamicField(_ p1: Any) -> String {
    return L10n.tr("Localizable", "rrm_error_empty_dynamic_field", String(describing: p1))
  }
  internal static var rrmErrorEmptyNumber: String { return L10n.tr("Localizable", "rrm_error_empty_number") }
  internal static var rrmValidationTitle: String { return L10n.tr("Localizable", "rrm_validation_title") }
  internal static var rrmValidationReviewInstruction: String { return L10n.tr("Localizable", "rrm_validation_review_instruction") }
  internal static func rrmErrorMinlengthNumber(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "rrm_error_minlength_number", String(describing: p1), String(describing: p2))
  }
  internal static var rrmRecipientNewDestinationCountry: String { return L10n.tr("Localizable", "rrm_recipient_new_destination_country") }
  internal static var rrmCommonSourceCountryName: String { return L10n.tr("Localizable", "rrm_common_source_country_name") }
  internal static var rrmErrorAmountRequired: String { return L10n.tr("Localizable", "rrm_error_amount_required") }
  internal static var rrmCommonIBAN: String { return L10n.tr("Localizable", "rrm_common_iban") }
  internal static var rrmCommonBIC: String { return L10n.tr("Localizable", "rrm_common_bic") }
  internal static var rrmCommonOk: String { return L10n.tr("Localizable", "rrm_common_ok") }
  internal static var rrmSelectCountryCallingCodeTitle: String { return L10n.tr("Localizable", "rrm_select_country_calling_code_title") }
  internal static var rrmPreviewCostSent: String { return L10n.tr("Localizable", "rrm_preview_cost_sent") }
  internal static func rrmSelectDynamicField(_ p1: Any) -> String {
    return L10n.tr("Localizable", "rrm_select_dynamic_field", String(describing: p1))
  }
  internal static var rrmErrorInvalidDate: String { return L10n.tr("Localizable", "rrm_error_invalid_date") }
  internal static var rrmErrorMonth: String { return L10n.tr("Localizable", "rrm_error_month") }
  internal static var rrmErrorYear: String { return L10n.tr("Localizable", "rrm_error_year") }
  internal static var rrmCommonMonth: String { return L10n.tr("Localizable", "rrm_common_month") }
  internal static var rrmCommonDay: String { return L10n.tr("Localizable", "rrm_common_day") }
  internal static var rrmCommonYear: String { return L10n.tr("Localizable", "rrm_common_year") }
  internal static var rrmCommonPlaceholderSelect: String { return L10n.tr("Localizable", "ready_remit_common_placeholder_select") }
  internal static var readyRemitCommonYearFormat: String { return L10n.tr("Localizable", "ready_remit_common_year_format") }
  internal static var rrmErrorNetworkTitle: String { return L10n.tr("Localizable", "rrm_error_network_title") }
  internal static var rrmErrorUnexpectedTitle: String { return L10n.tr("Localizable", "rrm_error_unexpected_title") }
  internal static var rrmErrorApiTitle: String { return L10n.tr("Localizable", "rrm_error_api_title") }
  internal static var rrmErrorNetworkMessage: String { return L10n.tr("Localizable", "rrm_error_network_message") }
  internal static var rrmErrorUnexpectedMessage: String { return L10n.tr("Localizable", "rrm_error_unexpected_message") }
  internal static var rrmErrorApiMessage: String { return L10n.tr("Localizable", "rrm_error_api_message") }
  internal static var rrmCommonValidationSuccess: String { return L10n.tr("Localizable", "rrm_common_validation_success") }
  internal static var rrmCommonReadMore: String { return L10n.tr("Localizable", "rrm_common_read_more") }
  internal static var rrmErrorTryAgain: String { return L10n.tr("Localizable", "rrm_error_try_again") }
  internal static var rrmSelectCurrencyTitle: String { return L10n.tr("Localizable", "rrm_select_currency_title") }
  internal static var rrmSenderDetailsTitle: String { return L10n.tr("Localizable", "rrm_sender_details_title") }
  internal static var rrmRecipientBankAccountDetails: String { return L10n.tr("Localizable", "rrm_recipient_bank_account_details") }
  internal static var rrmTransferReceiptTitle: String { return L10n.tr("Localizable", "rrm_transfer_receipt_title") }
  
  internal static var rrmConfirmationNumberTitle : String { return L10n.tr("Localizable", "rrm_confirmation_number_title") }
  internal static var rrmTransferDateTitle : String { return L10n.tr("Localizable", "rrm_transfer_date_title") }
  internal static var rrmDateAvailableTitle : String { return L10n.tr("Localizable", "rrm_date_available_title") }
  internal static var rrmCustomerDetailsName : String { return L10n.tr("Localizable", "rrm_customer_details_name") }
  internal static var rrmCustomerDetailsAddressL1 : String { return L10n.tr("Localizable", "rrm_customer_details_address_l_1") }
  internal static var rrmCustomerDetailsCity : String { return L10n.tr("Localizable", "rrm_customer_details_city") }
  internal static var rrmCustomerDetailsState : String { return L10n.tr("Localizable", "rrm_customer_details_state") }
  internal static var rrmCustomerDetailsCountry : String { return L10n.tr("Localizable", "rrm_customer_details_country") }
  internal static var rrmCustomerDetailsZip : String { return L10n.tr("Localizable", "rrm_customer_details_zip") }
  internal static var rrmCustomerDetails : String { return L10n.tr("Localizable", "rrm_customer_details_title") }
  
  internal static var rrmCountryId : String { return L10n.tr("Localizable", "rrm_country_id") }
  internal static var rrmVerifyTopText : String { return L10n.tr("Localizable", "rrm_verify_top_text") }
  internal static var rrmVerifyBottomText : String { return L10n.tr("Localizable", "rrm_verify_bottom_text") }
  internal static var rrmVerifyDocumentButton : String { return L10n.tr("Localizable", "rrm_verify_document_button") }
  internal static var rrmVerifyTitle : String { return L10n.tr("Localizable", "rrm_verify_title") }
  internal static var rrmNoCountrySelected : String { return L10n.tr("Localizable", "rrm_no_country_selected") }
  internal static var rrmVerifyRetry : String { return L10n.tr("Localizable", "rrm_verify_retry") }
  internal static var rrmVerifyAccept : String { return L10n.tr("Localizable", "rrm_verify_accept") }
  internal static var rrmVerifyDisclaimer : String { return L10n.tr("Localizable", "rrm_verify_disclaimer") }
  
  internal static var rrmFrontPicTitle : String { return L10n.tr("Localizable", "rrm_front_pic_title") }
  internal static var rrmFrontPicMessage : String { return L10n.tr("Localizable", "rrm_front_pic_message") }
  internal static var rrmBackPicTitle : String { return L10n.tr("Localizable", "rrm_back_pic_title") }
  internal static var rrmBackPicMessage : String { return L10n.tr("Localizable", "rrm_back_pic_message") }
  internal static var rrmFacePicTitle : String { return L10n.tr("Localizable", "rrm_face_pic_title") }
  internal static var rrmFacePicMessage : String { return L10n.tr("Localizable", "rrm_face_pic_message") }
  
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    var languageSelected: String = ""
    if UserDefaults.standard.string(forKey: "languageSelected") != nil {
      languageSelected = UserDefaults.standard.string(forKey: "languageSelected")!
    }else {
      languageSelected = "en"
    }
    
    let path = BundleToken.bundle.path(forResource: languageSelected, ofType: "lproj")
    let bundle = Bundle(path: path!)
    
    return String.init(
      format: NSLocalizedString(key, tableName: table, bundle: bundle!, value: "", comment: ""),
      arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static var bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(identifier: "com.brightwellpayments.ReadyRemitSDK")
    #endif
  }()!
}
// swiftlint:enable convenience_type

