//
//  home.swift
//  tt (iOS)
//
//  Created by Willy on 2022/8/11.
//

import SwiftUI
struct cellButtonView: View {
    @State var Item: item
    @ObservedObject var Groups: group

    @State private var showingSheet = false
    var body: some View{
        Button(
            action: {
                showingSheet.toggle()
            },
            label: {
                Text(Item.iname).padding(10)
            }
        ).sheet(isPresented: $showingSheet) {
            ItemView(
                myGroupData:    Groups,
                myItemData:     Item,
                peoplePay:      Item.peoplePayDict
            )
        }
    }
}

struct trashButtonView: View{
    @State var Items: item
    @ObservedObject var Groups: group
    @State private var delete_flag = false
    
    var body: some View{
        Button(
            action: {delete_flag = true},
            label:{Image(systemName: "trash")}
        )
        .alert(isPresented: $delete_flag) {
            Alert(
                title: Text("Are you sure want to delete the item : \(Items.iname)"),
                primaryButton: .default(
                    Text("No"),
                    action: {delete_flag = false
                        print(Items.iname)
                    }
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        print(Items.iname)
                        group.removeItem(myGroup: Groups, Item: Items)

                    }
                )
            )
        }
    }
}

struct groupView: View {
//    var ItemList: [String]=["food","play","train"]
    @ObservedObject var Group: group
    @State var showAddMember = false
    @State var showMember_flag = false
    @State var modify_flag = false
    
    @State private var showingaddItem = false
    @State private var peopleIsIn:[Bool] = []
    var body: some View{

        ZStack{
            VStack{
                HStack{
                    Spacer()
                    Button(
                        action: {showAddMember = true},
                        label: {
                            HStack{Text("add member");Image(systemName: "person.badge.plus")}
                        }
                    )
                    .padding()
                }
                
                Spacer()
                Text(Group.gname)
                Spacer()
                
                ForEach(Group.item_list, id: \.iid) { Item in
                    HStack{
                        Spacer()
                        cellButtonView(Item: Item, Groups: Group)
                        if modify_flag{
                            trashButtonView(Items: Item, Groups: Group)
                        }
                        Spacer()
                    }
                    .font(.caption)
                    .background(Color.red)
                    }
            
                
                Spacer()
                HStack{
                    Spacer()
                    Button("add item"){
                        showingaddItem.toggle()

                    }.sheet(isPresented: $showingaddItem) {
                        let isSelectAry = [Bool](repeating: false, count: Group.people_list.count)
                        Add_item_View(myGroupData: Group, isIn: isSelectAry)
                    }
                    Spacer()
                    if modify_flag{
                        Button("done"){modify_flag = false}
                    }
                    else{
                        Button("modify"){modify_flag = true}
                    }
                    
                    Spacer()
                } .foregroundColor(Color.yellow)
                Spacer()
                Button(
                    action: {showMember_flag = true},
                    label: {
                        HStack{
                            Text("member")
                            Image(systemName: "person.3")
                        }
                    }
                )
                Spacer()
            }
            if showAddMember{
                Color.black
                .opacity(0.3)
                .onTapGesture{
                    showAddMember = false
                    }
                .ignoresSafeArea()
                ZStack {
                    Color.blue.frame(height: 250)
                    .frame(maxWidth: .infinity)
                    VStack{
                        Text("This group ID:")
                        Text("\(self.Group.gid)")
                    }
                    
                }
                
            
            }
            if showMember_flag{
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture{
                        showMember_flag = false
                    }
                showMember
            }
        }
            
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//        .ignoresSafeArea()
//        .animation(.easeInOut)
        
    }
    var showMember: some View{
        ZStack{
            Color.blue
                .frame(width: UIScreen.main.bounds.width*0.6, height: UIScreen.main.bounds.height*0.3)
                .frame(maxWidth: .infinity)
            VStack{
                HStack{
                    ForEach(0 ..< self.Group.people_list.count, id: \.self) { idx in
                        Text(self.Group.people_list[idx].name)
                            .font(.system(size: 20, weight: .light, design: .serif))
                    }
                }
                
            }
        }
        .transition(.move(edge: .bottom))
    }
}
//
//struct groupView_Previews: PreviewProvider {
//    static var previews: some View {
//        groupView(group: Group)
//    }
//}
