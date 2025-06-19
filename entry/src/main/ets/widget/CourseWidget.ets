import { CourseItem } from '../models/CourseModel';

// 添加FormData相关接口定义
interface FormCourseData {
  id: string;
  name: string;
  classroom: string;
  timeSlot: number;
  duration: number;
  color: string;
}

interface FormData {
  courses: FormCourseData[];
}

@Component
export struct CourseWidget {
  @State courses: CourseItem[] = [];
  
  aboutToAppear() {
    // 实际中，这部分数据应该由FormAbility提供
    // 这里为了示例，提供一些模拟数据
    if (this.courses.length === 0) {
      this.courses = [
        new CourseItem('1', '高等数学', '张教授', 'A101', 1, 1, 2, 1, 16, '#4D7FFF'),
        new CourseItem('2', '大学英语', '李教授', 'B203', 2, 3, 2, 1, 16, '#FF6B6B'),
      ];
    }
  }

  // 示例：创建FormData的方法
  private createFormData(): FormData {
    const formData: FormData = {
      courses: this.courses.map((course): FormCourseData => ({
        id: course.id,
        name: course.name,
        classroom: course.classroom,
        timeSlot: course.timeSlot,
        duration: course.duration,
        color: course.color
      }))
    };
    return formData;
  }
  
  build() {
    Column() {
      // 标题
      Row() {
        Text('今日课程')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(8)
      
      // 课程列表
      if (this.courses.length > 0) {
        List() {
          ForEach(this.courses, (course: CourseItem) => {
            ListItem() {
              Row() {
                // 颜色标记
                Column()
                  .width(4)
                  .height(40)
                  .backgroundColor(course.color)
                  .margin({ right: 8 })
                
                // 课程信息
                Column() {
                  Text(course.name)
                    .fontSize(14)
                    .fontWeight(FontWeight.Bold)
                  
                  Text(`${course.classroom} | 第${course.timeSlot}-${course.timeSlot + course.duration - 1}节`)
                    .fontSize(12)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .width('100%')
              .padding(8)
            }
          })
        }
        .width('100%')
      } else {
        // 无课程时显示
        Row() {
          Text('今天没有课程')
            .fontSize(14)
        }
        .width('100%')
        .height(40)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffff')
    .borderRadius(8)
    .padding(8)
  }
}

// 用于预览的入口组件
@Entry
@Component
struct WidgetPreview {
  build() {
    Column() {
      CourseWidget()
        .width('100%')
        .height(180)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
    .padding(16)
  }
}