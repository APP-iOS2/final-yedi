//
//  RegisterView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI
    
struct RegisterView: View {
    var userType: UserType
    
    @EnvironmentObject private var userAuth: UserAuth
    @Environment(\.dismiss) private var dismiss
    
    private let authRegex = AuthRegex.shared
    
    @State private var birthPicker = Date()
    
    /// 고객, 디자이너 공통 프로퍼티
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var profileImageURLString: String = ""
    @State private var password: String = ""
    @State private var doubleCheckPassword: String = ""
    /// 고객 프로퍼티 (연산프로퍼티 birthDate 포함)
    @State private var selectedGender: String = "여성"
    /// 디자이너 프로퍼티
    @State private var description: String = ""
    @State private var rank: Rank = .Owner
    @State private var shop: Shop = .init(shopName: "", headAddress: "", subAddress: "", detailAddress: "", openingHour: "", closingHour: "", closedDays: [])
    @State private var isShowDesignerShopEditView: Bool = false
    
    /// caution 프로퍼티
    @State private var cautionEmail: String = ""
    @State private var cautionPassword: String = ""
    @State private var cautionDoubleCheckPassword: String = ""
    @State private var cautionName: String = ""
    @State private var cautionPhoneNumber: String = ""
    @State private var cautionBirth: String = ""
    /// valid 프로퍼티
    @State private var isEmailValid: Bool = true
    @State private var isPasswordValid: Bool = true
    @State private var isDoubleCheckPasswordValid: Bool = true
    @State private var isPhoneNumberValid: Bool = true
    @State private var isBirthValid: Bool = true
    /// empty 프로퍼티
    @State private var isNotEmptyName: Bool = true
    @State private var isNotEmptyDescription: Bool = true
    /// birth 프로퍼티
    @State private var changedBirthText: String = "생년월일"
    @State private var tempDate: Date = Date()
    private let genders: [String] = ["여성", "남성"]
    private let ranks: [Rank] = [.Owner, .Principal, .Designer, .Intern]
    
    private var birthDate: String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: birthPicker)
    }
    
    var body: some View {
        VStack {
            switch userType {
            case .client:
                registerForClient
            case .designer:
                registerForDesigner
            }
        }
    }
    
    private var registerForClient: some View {
        VStack(alignment: .leading) {
            ScrollView {
                inputUserInfo(.client)
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            RegisterButton(.client)
        }
        .navigationTitle("고객 회원가입")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                DismissButton(color: nil) { }
            }
        }
    }
    
    private var registerForDesigner: some View {
        VStack(alignment: .leading) {
            ScrollView {
                inputUserInfo(.designer)
                inputDesignerDescription
                inputDesignerRank
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            RegisterButton(.designer)
        }
        .navigationTitle("디자이너 회원가입")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                DismissButton(color: nil) { }
            }
        }
    }
    
    private func inputUserInfo(_ userType: UserType) -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 5) {
                Text("이메일 *")
                TextField("이메일", text: $email)
                    .keyboardType(.emailAddress)
                    .signInTextFieldStyle(isTextFieldValid: $isEmailValid)
                    .onChange(of: email) { newValue in
                        if !checkEmail() {
                            email = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                if isEmailValid {
                    Text(cautionEmail)
                        .font(.caption)
                        .foregroundStyle(.blue)
                } else {
                    Text(cautionEmail)
                        .cautionTextStyle()
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("패스워드 *")
                TextField("패스워드", text: $password)
                    .signInTextFieldStyle(isTextFieldValid: $isPasswordValid)
                    .onChange(of: password) { newValue in
                        if !checkPassword() {
                            password = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                Text(cautionPassword)
                    .cautionTextStyle()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("패스워드 체크 *")
                TextField("패스워드 체크", text: $doubleCheckPassword)
                    .signInTextFieldStyle(isTextFieldValid: $isDoubleCheckPasswordValid)
                    .onChange(of: doubleCheckPassword) { newValue in
                        if !doubleCheckPasswordValid() {
                            doubleCheckPassword = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                Text(cautionDoubleCheckPassword)
                    .cautionTextStyle()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("이름 *")
                TextField("이름", text: $name)
                    .signInTextFieldStyle(isTextFieldValid: $isNotEmptyName)
                    .onChange(of: name) { newValue in
                        if !checkEmptyName() {
                            name = newValue.trimmingCharacters(in: .whitespaces)
                        }
                            
                    }
                
                Text(cautionName)
                    .cautionTextStyle()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("휴대폰 번호 *")
                TextField("휴대폰 번호", text: $phoneNumber)
                    .keyboardType(.numberPad)
                    .signInTextFieldStyle(isTextFieldValid: $isPhoneNumberValid)
                    .onChange(of: phoneNumber) { newValue in
                        if !checkPhoneNumber() {
                            phoneNumber = newValue.trimmingCharacters(in: .whitespaces)
                        }
                    }
                
                Text(cautionPhoneNumber)
                    .cautionTextStyle()
            }
            
            VStack(alignment: .leading) {
                Text("생년월일 *")
                HStack {
                    Text(changedBirthText)
                        .foregroundStyle(changedBirthText=="생년월일" ? Color.placeholderText : Color.primaryLabel)
                    
                    Spacer()
                    Image(systemName: "calendar")
                        .overlay {
                            DatePicker("birth", selection: $birthPicker, in: ...Date(), displayedComponents: .date)
                                .blendMode(.destinationOver)
                                .onChange(of: birthPicker, perform: { newValue in
                                    if checkBirth() {
                                        birthPicker = newValue
                                    }
                                })
                        }
                }
                .signInTextFieldStyle(isTextFieldValid: $isBirthValid)
                .onChange(of: birthPicker) { _ in
                    changedBirthText = birthDate
                }
                
                Text(cautionBirth)
                    .cautionTextStyle()
            }
            
            HStack(alignment: .center) {
                Text("성별 *")
                HStack(spacing: 0) {
                    ForEach(genders, id: \.self) { gender in
                        Button(action: {
                            selectedGender = gender
                        }, label: {
                            Text(gender)
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .foregroundStyle(Color.primaryLabel)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.gray6, lineWidth: 2)
                                )
                        })
                        .background(selectedGender == gender ? Color.gray4 : Color.gray6)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal)
    }
    
    private var inputDesignerRank: some View {
        
        VStack(alignment: .leading, spacing: 5)  {
            Button {
                isShowDesignerShopEditView = true
            } label: {
                Text("샵정보 입력")
            }

//            HStack(alignment: .center) {
//                Text("직급 *")
//                
//                Spacer()
//                
//                Menu(rank.rawValue) {
//                    Picker("select your rank", selection: $rank) {
//                        ForEach(ranks, id: \.self) { rank in
//                            Text(rank.rawValue)
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(11)
//                .foregroundStyle(Color.primary)
//                .background {
//                    RoundedRectangle(cornerRadius: 4)
//                        .fill(Color.quaternarySystemFill)
//                }
//            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $isShowDesignerShopEditView){
            DMShopEditView(shop: $shop,
                           rank: $rank,
                           isShowDesignerShopEditView: $isShowDesignerShopEditView)
        }
    }
    
    private var inputDesignerDescription: some View {
        VStack(alignment: .leading) {
            Text("소개글")
            TextField("디자이너 소개글", text: $description, axis: .vertical)
                .signInTextFieldStyle(isTextFieldValid: $isNotEmptyDescription)
        }
        .padding(.horizontal)
    }
    
    private func RegisterButton(_ userType: UserType) -> some View {
        VStack {
            Button {
                pressedButtonRegister(userType)
            } label: {
                Text("회원가입")
                    .buttonModifier(.mainColor)
            }
        }
        .padding([.horizontal, .bottom])
    }
    
    private func pressedButtonRegister(_ userType: UserType) {
        switch userType {
        case .client:
            if checkEmail() && checkPassword() && doubleCheckPasswordValid() && checkEmptyName() && checkPhoneNumber() && checkBirth()  {
                let client = Client(
                    id: UUID().uuidString,
                    name: name,
                    email: email,
                    profileImageURLString: "",
                    phoneNumber: phoneNumber,
                    gender: selectedGender,
                    birthDate: birthDate,
                    favoriteStyle: "",
                    chatRooms: []
                )
                userAuth.registerClient(client: client, password: password) { success in
                    if success {
                        cautionEmail = "사용 가능한 이메일입니다."
                        dismiss()
                    } else {
                        cautionEmail = "이미 존재하는 이메일입니다."
                        isEmailValid = false
                    }
                }
            }
        case .designer:
            if checkEmail() && checkPassword() && doubleCheckPasswordValid() && checkEmptyName() && checkPhoneNumber() {
                let designer = Designer(
                    id: nil,
                    name: name,
                    email: email,
                    phoneNumber: phoneNumber,
                    description: description,
                    designerScore: 0,
                    reviewCount: 0,
                    followerCount: 0,
                    skill: [],
                    chatRooms: [],
                    birthDate: birthDate,
                    gender: selectedGender,
                    rank: rank,
                    designerUID: ""
                )
                
                userAuth.registerDesigner(designer: designer, shop: shop, password: password) { success in
                    if success {
                        cautionEmail = "사용 가능한 이메일입니다."
                        dismiss()
                    } else {
                        cautionEmail = "이미 존재하는 이메일입니다."
                        isEmailValid = false
                    }
                }
            }
        }
    }
    
    private func checkEmail() -> Bool {
        if authRegex.checkEmailValid(email) {
            cautionEmail = ""
            isEmailValid = true
        } else if !authRegex.checkEmailValid(email) {
            cautionEmail = "올바르지 않은 이메일 주소입니다"
            isEmailValid = false
        }
        return isEmailValid
    }
    
    private func checkPassword() -> Bool {
        if authRegex.checkPasswordValid(password) {
            cautionPassword = ""
            isPasswordValid = true
        } else {
            cautionPassword = "알파벳, 숫자를 이용하여 6자 이상의 비밀번호를 입력해주세요."
            isPasswordValid = false
        }
        return isPasswordValid
    }
    
    private func doubleCheckPasswordValid() -> Bool {
        if password == doubleCheckPassword {
            cautionDoubleCheckPassword = ""
            isDoubleCheckPasswordValid = true
        } else {
            cautionDoubleCheckPassword = "패스워드가 일치하지 않습니다."
            isDoubleCheckPasswordValid = false
        }
        return isDoubleCheckPasswordValid
    }
    
    private func checkEmptyName() -> Bool {
        if !name.isEmpty {
            cautionName = ""
            isNotEmptyName = true
        } else {
            cautionName = "필수 입력사항입니다."
            isNotEmptyName = false
        }
        return isNotEmptyName
    }
    
    private func checkPhoneNumber() -> Bool {
        if authRegex.checkPhoneNumberValid(phoneNumber) {
            cautionPhoneNumber = ""
            isPhoneNumberValid = true
        } else {
            cautionPhoneNumber = "올바르지 않은 휴대폰 번호입니다"
            isPhoneNumberValid = false
        }
        return isPhoneNumberValid
    }
    
    private func checkBirth() -> Bool {
        if birthPicker > Date() {
            cautionBirth = "올바르지 않은 생년월일입니다"
            isBirthValid = false
        } else {
            cautionBirth = ""
            isBirthValid = true
        }
        return isBirthValid
    }
}

#Preview(body: {
    NavigationStack{
        RegisterNavigationView(userType: .designer)
    }
})
