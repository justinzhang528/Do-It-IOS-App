import SwiftUI
import UserNotifications
import Foundation
 
 struct TimerView: View {
    var listIndex: Int
    var taskIndex: Int
     var body: some View {
        ZStack{
            
            GeometryReader { geo in
                Image("Important")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }

            Home(listIndex: self.listIndex, taskIndex: taskIndex)
        }
     }
 }
 
 struct TimerView_Previews: PreviewProvider {
     static var previews: some View {
         TimerView(listIndex: 0, taskIndex: 0)
     }
 }
 
 struct Home : View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ToDoList.getAlltoDoLists()) var toDoLists: FetchedResults<ToDoList>
    
    var listIndex: Int
    var taskIndex: Int
     let startTime = 1500
     @State var start = false
     @State var isShowAlert = false
     @State var to : CGFloat = 0
     @State var count = 0
     @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
     
     var body: some View{
         
         ZStack{
             
             Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
             
             
             VStack{
                 
                 ZStack{
                     
                     Circle()
                     .trim(from: 0, to: 1)
                         .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 15, lineCap: .butt))
                     .frame(width: 280, height: 280)
                     
                     Circle()
                         .trim(from: 0, to: self.to)
                         .stroke(Color.red, style: StrokeStyle(lineWidth: 15, lineCap: .butt))
                     .frame(width: 280, height: 280)
                     .rotationEffect(.init(degrees: -90))
                     
                     
                     VStack{
                         
                        Text("\(TimeConverter().Convert(time: self.count))")
                             .font(.system(size: 65))
                             .fontWeight(.bold)
                     }
                 }
                 
                 HStack(spacing: 20){
                     
                     Button(action: {
                         
                         if self.count == 0{
                             
                            self.count = self.startTime
                             withAnimation(.default){
                                 
                                self.to = CGFloat(self.startTime)
                             }
                         }
                         self.start.toggle()
                         
                     }) {
                         
                         HStack(spacing: 15){
                             
                             Image(systemName: self.start ? "pause.fill" : "play.fill")
                                 .foregroundColor(.white)
                             
                             Text(self.start ? "Pause" : "Play")
                                 .foregroundColor(.white)
                         }
                         .padding(.vertical)
                         .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                         .background(Color.red)
                         .clipShape(Capsule())
                         .shadow(radius: 6)
                     }
                     
                     Button(action: {
                         
                        self.count = self.startTime
                         
                         withAnimation(.default){
                             
                            self.to = CGFloat(self.startTime)
                         }
                         
                     }) {
                         
                         HStack(spacing: 15){
                             
                             Image(systemName: "arrow.clockwise")
                                 .foregroundColor(.red)
                             
                             Text("Restart")
                                 .foregroundColor(.red)
                             
                         }
                         .padding(.vertical)
                         .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                         .background(
                         
                             Capsule()
                                 .stroke(Color.red, lineWidth: 2)
                         )
                         .shadow(radius: 6)
                     }
                 }
                 .padding(.top, 55)
             }
             
         }
         .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Pomodoro"), message: Text("Choose action:"), primaryButton: .default(Text("Continue"), action: {
               print("")
            }), secondaryButton: .default(Text("Mark the task as Completed"), action: {
                let task = self.toDoLists[self.listIndex].tasks[self.taskIndex]
                self.toDoLists[4].tasks.append(task)
                self.toDoLists[self.listIndex].tasks.remove(at: self.taskIndex)
                
                do{
                    try self.managedObjectContext.save()
                }catch{
                    print(error)
                }
                
                
                
            }))
            }
            
         .onAppear(perform: {
            
            self.count = self.startTime
            self.to = CGFloat(self.startTime)
             
             UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { (_, _) in
             }
         })
         .onReceive(self.time) { (now) in
             
             if self.start{
                 
                 if self.count != 0{
                    
                    
                    self.count -= 1
                     
                     withAnimation(.default){
                         
                        self.to = CGFloat(self.count) / CGFloat(self.startTime)
                     }
                 }
                 else{
                     self.count = self.startTime
                     self.to = CGFloat(self.startTime)
                     self.start.toggle()
                     self.isShowAlert = true
                     self.Notify()
                 }
 
             }
             
         }
     }
     
     func Notify(){
         
         let content = UNMutableNotificationContent()
         content.title = "Pomodoro"
         content.body = "Timer Is Completed Successfully"
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
         
         let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
         
         UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
     }
 }


public class TimeConverter {
    
    public func Convert(time: Int) -> String {
        var minute: Int = 0
        var second: Int = 0
        var minuteString: String = ""
        var secondString: String = ""
        minute = time / 60
        second = time % 60
        
        if(minute > 9){
            minuteString = String(minute)
        }else if(minute > 0 && minute < 10){
            minuteString = "0" + String(minute)
        }else{
            minuteString = "00"
        }
        
        if(second > 9){
            secondString = String(second)
        }else if(second > 0 && second < 10){
            secondString = "0" + String(second)
        }else{
            secondString = "00"
        }
        
        return minuteString + " : " + secondString
    }
}
