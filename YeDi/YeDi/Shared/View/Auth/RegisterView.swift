//
//  RegisterView.swift
//  YeDi
//
//  Created by yunjikim on 2023/10/06.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userAuth: UserAuth
    @State var userType: UserType?
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink {
                RegisterNavigationView(userType: .client)
            } label: {
                Text("고객 회원가입")
            }
            NavigationLink {
                RegisterNavigationView(userType: .designer)
            } label: {
                Text("디자이너 회원가입")
            }
        }
    }
}
    
struct RegisterNavigationView: View {
    @State var userType: UserType
    
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.dismiss) private var dismiss
    
    @State var birthPicker = Date()
    
    /// 고객, 디자이너 공통 프로퍼티
    @State var name: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var profileImageURLString: String = ""
    @State var password: String = ""
    @State var doubleCheckPassword: String = ""
    /// 고객 프로퍼티 (연산프로퍼티 birthDate 포함)
    @State private var selectedGender: String = "여성"
    /// 디자이너 프로퍼티
    @State var description: String = ""
    @State var rank: Rank = .Owner
    /// caution 프로퍼티
    @State var cautionEmail: String = ""
    @State var cautionPassword: String = ""
    @State var cautionDoubleCheckPassword: String = ""
    @State var cautionName: String = ""
    @State var cautionPhoneNumber: String = ""
    @State var cautionBirth: String = ""
    /// valid 프로퍼티
    @State var isEmailValid: Bool = true
    @State var isPasswordValid: Bool = true
    @State var isDoubleCheckPasswordValid: Bool = true
    @State var isPhoneNumberValid: Bool = true
    @State var isBirthValid: Bool = true
    /// empty 프로퍼티
    @State var isNotEmptyName: Bool = true
    @State var isNotEmptyDescription: Bool = true
    /// birth 프로퍼티
    @State var changedBirthText: String = "생년월일"
    
    let genders: [String] = ["여성", "남성"]
    let ranks: [Rank] = [.Owner, .Principal, .Designer, .Intern]
    
    var birthDate: String {
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
    
    var registerForClient: some View {
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
    }
    
    var registerForDesigner: some View {
        VStack(alignment: .leading) {
            ScrollView {
                inputUserInfo(.designer)
                inputDesignerRank
                inputDesignerDescription
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            RegisterButton(.designer)
        }
        .navigationTitle("디자이너 회원가입")
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
                        .foregroundColor(changedBirthText=="생년월일" ? .gray : .primary)
                    
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
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color(white: 0.9), lineWidth: 1)
                                )
                        })
                        .background(selectedGender == gender ? Color(white: 0.9) : .white)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
        .padding(.horizontal)
    }
    
    private var inputDesignerRank: some View {
        VStack(alignment: .leading) {
            Picker("select your rank", selection: $rank) {
                ForEach(ranks, id: \.self) { rank in
                    Text(rank.rawValue)
                }
            }
            .pickerStyle(.menu)
        }
        .padding(.horizontal)
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
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.black)
                    }
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
                
                userAuth.registerDesigner(designer: designer, password: password) { success in
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
        if checkEmailValid(email) {
            cautionEmail = ""
            isEmailValid = true
        } else if !checkEmailValid(email) {
            cautionEmail = "올바르지 않은 이메일 주소입니다"
            isEmailValid = false
        }
        return isEmailValid
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func checkPassword() -> Bool {
        if checkPasswordValid(password) {
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
    
    private func checkPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
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
        if checkPhoneNumberValid(phoneNumber) {
            cautionPhoneNumber = ""
            isPhoneNumberValid = true
        } else {
            cautionPhoneNumber = "올바르지 않은 휴대폰 번호입니다"
            isPhoneNumberValid = false
        }
        return isPhoneNumberValid
    }
    
    private func checkPhoneNumberValid(_ phoneNumber: String) -> Bool {
        let regex = "^01([0|1|6|7|8|9]?) ?([0-9]{4}) ?([0-9]{4})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phoneNumber)
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
