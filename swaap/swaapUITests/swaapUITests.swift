//
//  swaapUITests.swift
//  swaapUITests
//
//  Created by Marlon Raskin on 11/11/19.
//  Copyright © 2019 swaap. All rights reserved.
//

import XCTest

class SwaapUITests: XCTestCase {

	var app: XCUIApplication!

	override func setUp() {
		super.setUp()

		continueAfterFailure = false
		app = XCUIApplication()
		app.launchArguments = ["UITesting"]
		app.launch()
	}

	// MARK: - Helper Methods
	func showFloatingTextFieldViaSocialContactMethodButton() {
		scrollDown()
		app.buttons["EditVC.AddContactMethodButton"].tap()
	}

	func showFloatingTextFieldViaBasicInfoView(identifier: String) {
		let field = app.otherElements.element(matching: .other, identifier: identifier)
		field.tap()
	}

	func scrollDown() {
		app.swipeUp()
	}

	func scrollUp() {
		app.swipeDown()
	}

	func saveProfileChanges() {
		app.navigationBars["Edit Profile"].buttons["Save"].tap()
	}

	// MARK: - Navigate to Detail View
	func navigateToProfileCardView() {
		app.tables["Jake Callahan"].staticTexts["ProfileHeaderLabel"].tap()
	}

	func backToTableViewFromProfileCardView() {
		app.buttons["ProfileBackButton"].tap()
	}

	func navigateToEditProfileVC() {
		app.tables["Jake Callahan"].staticTexts["ProfileHeaderLabel"].tap()
		app.buttons["EditButton"].tap()
	}


	// MARK: - EditVC Tests
	func testEditProfileNavBarTitle() {
		navigateToEditProfileVC()
		XCTAssertTrue(app.navigationBars["Edit Profile"].exists)
	}

	func testEditProfileVCDismissesAfterSaveButtonTap() {
		navigateToEditProfileVC()
		XCTAssertTrue(app.navigationBars["Edit Profile"].exists)
		saveProfileChanges()
		XCTAssertFalse(app.navigationBars["Edit Prodile"].exists)
	}

	func testAddSocialLinkButtonAppearsOnScroll() {
		navigateToEditProfileVC()
		scrollDown()
		XCTAssertTrue(app.buttons["EditVC.AddContactMethodButton"].isHittable)
	}

	func testAddSocialLinkButtonAppearsAndDisappearsOnScroll() {
		navigateToEditProfileVC()
		scrollDown()
		XCTAssertTrue(app.buttons["EditVC.AddContactMethodButton"].isHittable)
		scrollUp()
		XCTAssertFalse(app.buttons["EditVC.AddContactMethodButton"].isHittable)
	}

	// MARK: - FloatingTextField Tests
	func testInputVCIsShowing() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		XCTAssertTrue(app.isDisplayingInputTextFieldVC)
	}

	func testPlaceholderTextWhenAddContactMethodButtonIsTapped() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		let floatingTextField = app.textFields.element
		XCTAssertTrue(floatingTextField.placeholderValue == "choose type →")
	}

	func testSaveButtonDisabledOnTextFieldLaunchWhenAddingContactMethod() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		let saveButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.SaveButton")
		// Adding sleep here because there's a split second where the save button is enabled before if realizes it shouldn't be
		sleep(1)
		XCTAssertFalse(saveButton.isEnabled)
	}

	func testSaveButtonStillDisabledWhenOnlyTextIsAdded() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		let saveButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.SaveButton")
		// Adding sleep here because there's a split second where the save button is enabled before if realizes it shouldn't be
		sleep(1)
		XCTAssertFalse(saveButton.isEnabled)
		let floatingTextField = app.textFields.element
		floatingTextField.typeText("I'm testing you!")
		XCTAssertFalse(saveButton.isEnabled)
	}

	func testCollectionViewIsHiddenAtTextFieldLaunchAndUnhidesWithButtonTap() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		let collectionView = app.collectionViews.element
		XCTAssertFalse(collectionView.exists)
		let plusButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.PlusButton")
		XCTAssertTrue(plusButton.isHittable)
		plusButton.tap()
		XCTAssertTrue(collectionView.exists)
		XCTAssertEqual(collectionView.cells.count, 7)
	}

	func testTextFieldAddSocialButtonWhenCollectionViewCellIsTapped() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		let collectionView = app.collectionViews.element
		let plusButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.PlusButton")
		let socialButton = app.otherElements.element(matching: .other, identifier: "FloatingTextField.SocialButton")
		XCTAssertTrue(plusButton.isHittable)
		XCTAssertFalse(socialButton.exists)
		plusButton.tap()
		XCTAssertTrue(collectionView.exists)
		collectionView.cells.element(boundBy: 0).tap()
		XCTAssertFalse(plusButton.exists)
		let exists = socialButton.waitForExistence(timeout: 1)
		XCTAssertTrue(exists)
		XCTAssertTrue(socialButton.isHittable)
	}

	func testPlaceholderTextMatchesSocialButtonType() {
		let collectionView = app.collectionViews.element
		let textField = app.textFields.element
		let plusButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.PlusButton")
		let socialButton = app.otherElements.element(matching: .other, identifier: "FloatingTextField.SocialButton")
		let emailCell = collectionView.cells.element(boundBy: 0)
		let instagramCell = collectionView.cells.element(boundBy: 3)
		let emailPlaceholderStr = "add an email address"
		let instagramPlaceholderStr = "add your Instagram username"
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		plusButton.tap()
		emailCell.tap()
		XCTAssertEqual(textField.placeholderValue, emailPlaceholderStr)
		socialButton.tap()
		instagramCell.tap()
		XCTAssertEqual(textField.placeholderValue, instagramPlaceholderStr)
	}

	func testAtSymbolHidesAndUnhidesToMatchSocialType() {
		let collectionView = app.collectionViews.element
		let plusButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.PlusButton")
		let socialButton = app.otherElements.element(matching: .other, identifier: "FloatingTextField.SocialButton")
		let emailCell = collectionView.cells.element(boundBy: 0)
		let instagramCell = collectionView.cells.element(boundBy: 3)
		let atSymbol = app.staticTexts.element(matching: .staticText, identifier: "FloatingTextField.@")
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		XCTAssertFalse(atSymbol.exists)
		plusButton.tap()
		emailCell.tap()
		XCTAssertFalse(atSymbol.exists)
		socialButton.tap()
		instagramCell.tap()
		XCTAssertTrue(atSymbol.exists)
		socialButton.tap()
		emailCell.tap()
		XCTAssertFalse(atSymbol.exists)
	}

	func testPlaceholderTextMatchesBasicInfoField() {
		navigateToEditProfileVC()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.NameField")
		let textField = app.textFields.element
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "Enter your full name")
		app.buttons["Cancel"].tap()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.TaglineField")
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "Add your tagline")
		app.buttons["Cancel"].tap()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.JobTitleField")
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "Add your job title")
		app.buttons["Cancel"].tap()
		scrollDown()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.LocationField")
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "Name of city")
		app.buttons["Cancel"].tap()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.IndustryField")
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "Add the industry you're in")
		app.buttons["Cancel"].tap()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.BirthdayField")
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "MM/DD/YYYY")
		app.buttons["Cancel"].tap()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.BioField")
		textField.buttons["Clear text"].tap()
		XCTAssertEqual(textField.placeholderValue, "Add a short bio")
	}

	func testSocialButtonElementsAreHiddenForBasicInfoInput() {
		let plusButton = app.buttons.element(matching: .button, identifier: "FloatingTextField.PlusButton")
		let atSymbol = app.staticTexts.element(matching: .staticText, identifier: "FloatingTextField.@")
		let separator = app.otherElements.element(matching: .other, identifier: "FloatingTextField.Separator")
		navigateToEditProfileVC()
		showFloatingTextFieldViaSocialContactMethodButton()
		XCTAssertTrue(plusButton.exists)
		XCTAssertTrue(separator.exists)
		XCTAssertFalse(atSymbol.exists)
		app.buttons["Cancel"].tap()
		scrollUp()
		showFloatingTextFieldViaBasicInfoView(identifier: "EditVC.NameField")
		XCTAssertFalse(plusButton.exists)
		XCTAssertFalse(atSymbol.exists)
		XCTAssertFalse(separator.exists)
	}
}

extension XCUIApplication {
	var isDisplayingInputTextFieldVC: Bool {
		return otherElements["InputTextFieldVC"].exists
	}
}
