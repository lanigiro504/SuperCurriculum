import { CourseItem } from '../models/CourseModel';
import { CourseService } from '../services/CourseService';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import common from '@ohos.app.ability.common';

// 定义路由参数接口
interface RouteParams {
  courseId?: string;
}

@Entry
@Component
struct CourseDetail {
  @State course: CourseItem = new CourseItem();
  private courseService: CourseService = new CourseService();
  
  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    if (params && params.courseId) {
      this.loadCourse(params.courseId);
    } else {
      promptAction.showToast({
        message: '未指定课程ID',
        duration: 2000
      });
      router.back();
    }
  }
  
  async loadCourse(courseId: string): Promise<void> {
    try {
      const courses = await this.courseService.getCoursesByWeek(1); // 获取所有课程
      const course = courses.find(c => c.id === courseId);
      if (course) {
        this.course = course;
      } else {
        promptAction.showToast({
          message: '未找到课程信息',
          duration: 2000
        });
        router.back();
      }
    } catch (error) {
      promptAction.showToast({
        message: `加载课程失败: ${error}`,
        duration: 2000
      });
      router.back();
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
        Text('课程详情')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 16 })
        Blank()
        Button('编辑')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/CourseEdit',
              params: { courseId: this.course.id }
            });
          })
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      
      // 课程信息卡片
      Column() {
        Text(this.course.name)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 16 })
        
        Row() {
          Text('教师：')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text(this.course.teacher)
            .fontSize(16)
        }
        .width('100%')
        .margin({ top: 8 })
        
        Row() {
          Text('教室：')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text(this.course.classroom)
            .fontSize(16)
        }
        .width('100%')
        .margin({ top: 8 })
        
        Row() {
          Text('时间：')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text(`周${this.course.weekDay} 第${this.course.timeSlot}-${this.course.timeSlot + this.course.duration - 1}节`)
            .fontSize(16)
        }
        .width('100%')
        .margin({ top: 8 })
        
        Row() {
          Text('周次：')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
          Text(`第${this.course.weekStart}-${this.course.weekEnd}周`)
            .fontSize(16)
        }
        .width('100%')
        .margin({ top: 8 })
      }
      .width('90%')
      .padding(16)
      .backgroundColor('#f5f5f5')
      .borderRadius(12)
      .margin({ top: 20 })
      
      // 底部操作区
      Row() {
        Button('删除课程')
          .backgroundColor('#FF6B6B')
          .onClick(() => {
            // 添加确认对话框
            AlertDialog.show({
              title: '确认删除',
              message: `确定要删除课程 "${this.course.name}" 吗？`,
              primaryButton: {
                value: '取消',
                action: () => {
                  // 不执行任何操作
                }
              },
              secondaryButton: {
                value: '删除',
                action: () => {
                  // 删除课程并返回
                  this.courseService.deleteCourse(this.course.id).then(() => {
                    promptAction.showToast({
                      message: '课程已删除',
                      duration: 2000
                    });
                    router.back();
                  }).catch((error: Error | string) => {
                    promptAction.showToast({
                      message: `删除失败: ${error}`,
                      duration: 2000
                    });
                  });
                }
              }
            });
          })
      }
      .width('90%')
      .margin({ top: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
  }
}
