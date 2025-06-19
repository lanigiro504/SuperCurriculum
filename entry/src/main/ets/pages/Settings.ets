import { UserConfig } from '../models/CourseModel';
import { CourseService } from '../services/CourseService';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Settings {
  @State config: UserConfig = new UserConfig();
  @State showTimePicker: boolean = false;
  private courseService: CourseService = new CourseService();
  
  aboutToAppear() {
    this.loadConfig();
  }
  
  async loadConfig(): Promise<void> {
    this.config = await this.courseService.getUserConfig();
  }
  
  showTimePickerDialog(): void {
    this.showTimePicker = true;
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.back'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        Text('设置')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
        Blank()
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      
      // 设置项
      Column() {
        // 通知设置
        Row() {
          Text('开启课程通知')
            .fontSize(16)
          Blank()
          Toggle({ type: ToggleType.Switch, isOn: this.config.enableNotification })
            .onChange((isOn) => {
              this.config.enableNotification = isOn;
            })
        }
        .width('100%')
        .height(50)
        .padding({ left: 16, right: 16 })
        
        Divider().width('100%')
        
        // 提前通知时间
        Row() {
          Text('提前通知时间')
            .fontSize(16)
          Blank()
          Text(`${this.config.advanceMinutes} 分钟`)
            .fontSize(16)
        }
        .width('100%')
        .height(50)
        .padding({ left: 16, right: 16 })
        .onClick(() => {
          this.showTimePickerDialog();
        })
        
        Divider().width('100%')
        
        // 关于应用
        Row() {
          Text('关于应用')
            .fontSize(16)
          Blank()
          Text('>')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height(50)
        .padding({ left: 16, right: 16 })
        
        Divider().width('100%')
      }
      .width('100%')
      .margin({ top: 20 })
      .backgroundColor('#ffffff')
      .borderRadius(8)
      
      // 保存按钮
      Button('保存设置')
        .width('90%')
        .height(50)
        .margin({ top: 40 })
        .onClick(() => {
          this.courseService.updateUserConfig(this.config).then(() => {
            promptAction.showToast({
              message: '设置已保存',
              duration: 2000
            });
          }).catch((error: Error | string) => {
            promptAction.showToast({
              message: `保存失败: ${error}`,
              duration: 2000
            });
          });
        })
      
      // 时间选择对话框
      if (this.showTimePicker) {
        Stack() {
          // 背景遮罩
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('rgba(0, 0, 0, 0.5)')
            .onClick(() => {
              this.showTimePicker = false;
            })
          
          // 对话框内容
          Column() {
            Text('选择提前通知时间')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 20 })
            
            // 时间选项
            Column() {
              this.createTimeOption(5)
              this.createTimeOption(10)
              this.createTimeOption(15)
              this.createTimeOption(30)
            }
            .width('100%')
            
            // 按钮区域
            Row() {
              Button('取消')
                .onClick(() => {
                  this.showTimePicker = false;
                })
                .backgroundColor('#f0f0f0')
                .fontColor('#666666')
                .width('45%')
              
              Button('确定')
                .onClick(() => {
                  this.showTimePicker = false;
                  promptAction.showToast({
                    message: '设置已更新',
                    duration: 1000
                  });
                })
                .width('45%')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .margin({ top: 20 })
          }
          .width('80%')
          .padding(20)
          .backgroundColor('#ffffff')
          .borderRadius(12)
        }
        .position({ x: 0, y: 0 })
        .width('100%')
        .height('100%')
        .zIndex(1000)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
  
  @Builder
  createTimeOption(minutes: number) {
    Row() {
      Text(`${minutes} 分钟`)
        .fontSize(16)
        .layoutWeight(1)
      
      Radio({ value: minutes.toString(), group: 'timeGroup' })
        .checked(this.config.advanceMinutes === minutes)
        .onChange((isChecked: boolean) => {
          if (isChecked) {
            this.config.advanceMinutes = minutes;
          }
        })
    }
    .width('100%')
    .height(50)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.config.advanceMinutes = minutes;
    })
  }
}
