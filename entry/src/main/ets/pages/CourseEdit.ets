import { CourseItem } from '../models/CourseModel';
import { CourseService } from '../services/CourseService';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

// 定义路由参数接口
interface RouteParams {
  courseId?: string;
}

@Entry
@Component
struct CourseEdit {
  @State course: CourseItem = new CourseItem();
  @State isNewCourse: boolean = true;
  private courseService: CourseService = new CourseService();
  
  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    if (params && params.courseId) {
      this.isNewCourse = false;
      this.loadCourse(params.courseId);
    } else {
      // 生成随机颜色
      const colors = ['#4D7FFF', '#FF6B6B', '#33CC99', '#FFCE54', '#AC92EC', '#4FC1E9'];
      this.course.color = colors[Math.floor(Math.random() * colors.length)];
      this.course.id = Date.now().toString();
    }
  }
  
  async loadCourse(courseId: string): Promise<void> {
    const courses = await this.courseService.getCoursesByWeek(1); // 获取所有课程
    const course = courses.find(c => c.id === courseId);
    if (course) {
      // 创建副本，避免直接修改
      this.course = new CourseItem();
      this.course.id = course.id;
      this.course.name = course.name;
      this.course.teacher = course.teacher;
      this.course.classroom = course.classroom;
      this.course.weekDay = course.weekDay;
      this.course.timeSlot = course.timeSlot;
      this.course.duration = course.duration;
      this.course.weekStart = course.weekStart;
      this.course.weekEnd = course.weekEnd;
      this.course.color = course.color;
      // 移除 isInWeek 的赋值，因为它是一个方法
    }
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
        Text(this.isNewCourse ? '添加课程' : '编辑课程')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
        Blank()
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      
      // 表单
      Scroll() {
        Column() {
          TextInput({ 
            placeholder: '课程名称', 
            text: this.course.name 
          })
            .onChange((value: string) => {
              this.course.name = value;
            })
            .width('100%')
            .height(50)
            .margin({ top: 16 })
          
          TextInput({ 
            placeholder: '教师姓名', 
            text: this.course.teacher 
          })
            .onChange((value: string) => {
              this.course.teacher = value;
            })
            .width('100%')
            .height(50)
            .margin({ top: 16 })
          
          TextInput({ 
            placeholder: '教室地点', 
            text: this.course.classroom 
          })
            .onChange((value: string) => {
              this.course.classroom = value;
            })
            .width('100%')
            .height(50)
            .margin({ top: 16 })
          
          // 星期选择
          Row() {
            Text('星期')
              .fontSize(16)
              .width('20%')
            
            Slider({
              min: 1,
              max: 7,
              step: 1,
              value: this.course.weekDay
            })
              .onChange((value: number) => {
                this.course.weekDay = value;
              })
              .width('60%')
            
            Text(`周${this.course.weekDay}`)
              .fontSize(16)
              .width('20%')
              .textAlign(TextAlign.End)
          }
          .width('100%')
          .margin({ top: 24 })
          
          // 节次选择
          Row() {
            Text('开始节次')
              .fontSize(16)
              .width('30%')
            
            Select([
              { value: '1' },
              { value: '3' },
              { value: '5' },
              { value: '7' },
              { value: '9' }
            ])
              .selected(Math.floor((this.course.timeSlot - 1) / 2))
              .value(`${this.course.timeSlot}`)
              .onSelect((index: number, value: string) => {
                this.course.timeSlot = parseInt(value);
              })
              .width('70%')
          }
          .width('100%')
          .margin({ top: 16 })
          
          // 课程时长
          Row() {
            Text('课程时长')
              .fontSize(16)
              .width('30%')
            
            Select([
              { value: '2节' },
              { value: '3节' },
              { value: '4节' }
            ])
              .selected(this.course.duration - 2)
              .value(`${this.course.duration}节`)
              .onSelect((index: number, value: string) => {
                this.course.duration = index + 2;
              })
              .width('70%')
          }
          .width('100%')
          .margin({ top: 16 })
          
          // 周次范围
          Row() {
            Text('开始周')
              .fontSize(16)
              .width('20%')
            
            Counter() {
              Text(`${this.course.weekStart}`)
                .fontSize(16)
            }
            .onInc(() => {
              if (this.course.weekStart < this.course.weekEnd) {
                this.course.weekStart++;
              }
            })
            .onDec(() => {
              if (this.course.weekStart > 1) {
                this.course.weekStart--;
              }
            })
            .width('30%')
            
            Text('结束周')
              .fontSize(16)
              .width('20%')
            
            Counter() {
              Text(`${this.course.weekEnd}`)
                .fontSize(16)
            }
            .onInc(() => {
              if (this.course.weekEnd < 20) {
                this.course.weekEnd++;
              }
            })
            .onDec(() => {
              if (this.course.weekEnd > this.course.weekStart) {
                this.course.weekEnd--;
              }
            })
            .width('30%')
          }
          .width('100%')
          .margin({ top: 24 })
          
          // 颜色选择
          Column() {
            Text('课程颜色')
              .fontSize(16)
              .alignSelf(ItemAlign.Start)
            
            Row() {
              ForEach(['#4D7FFF', '#FF6B6B', '#33CC99', '#FFCE54', '#AC92EC', '#4FC1E9'], (color: string) => {
                Column() {
                  Circle({ width: 30, height: 30 })
                    .fill(color)
                    .stroke(this.course.color === color ? '#000000' : 'transparent')
                    .strokeWidth(2)
                    .onClick(() => {
                      this.course.color = color;
                    })
                }
                .width('16.6%')
                .alignItems(HorizontalAlign.Center)
              })
            }
            .width('100%')
            .margin({ top: 8 })
          }
          .width('100%')
          .margin({ top: 24 })
          
          // 保存按钮
          Button('保存')
            .width('100%')
            .height(50)
            .margin({ top: 40, bottom: 20 })
            .onClick(() => {
              if (!this.course.name || !this.course.classroom) {
                promptAction.showToast({
                  message: '课程名称和教室不能为空',
                  duration: 2000
                });
                return;
              }
              
              if (this.isNewCourse) {
                this.courseService.addCourse(this.course).then(() => {
                  promptAction.showToast({
                    message: '课程添加成功',
                    duration: 2000
                  });
                  router.back();
                }).catch((error: Error | string) => {
                  promptAction.showToast({
                    message: `添加失败: ${error}`,
                    duration: 2000
                  });
                });
              } else {
                this.courseService.updateCourse(this.course).then(() => {
                  promptAction.showToast({
                    message: '课程更新成功',
                    duration: 2000
                  });
                  router.back();
                }).catch((error: Error | string) => {
                  promptAction.showToast({
                    message: `更新失败: ${error}`,
                    duration: 2000
                  });
                });
              }
            })
        }
        .width('90%')
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}
