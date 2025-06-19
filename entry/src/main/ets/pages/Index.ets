import { CourseItem, TimeSlot, WeekDay } from '../models/CourseModel';
import { CourseService } from '../services/CourseService';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State currentWeek: number = 15;
  @State courses: CourseItem[] = [];
  @State currentTabIndex: number = 1; // 默认选中课程表
  private courseService: CourseService = new CourseService();
  private swiperController: SwiperController = new SwiperController();

  // 周数范围
  private readonly totalWeeks: number = 20;
  private readonly startWeek: number = 1;
  
  // 生成周数数组
  private weekNumbers: number[] = Array.from<number, number>({ length: this.totalWeeks }, (_, i: number) => i + this.startWeek);

  // 时间段配置
  private timeSlots: TimeSlot[] = [
    { label: '1', startTime: '08:30', endTime: '09:15' },
    { label: '2', startTime: '09:20', endTime: '10:05' },
    { label: '3', startTime: '10:25', endTime: '11:10' },
    { label: '4', startTime: '11:15', endTime: '12:00' },
    { label: '5', startTime: '13:00', endTime: '14:45' },
    { label: '6', startTime: '14:50', endTime: '15:35' },
    { label: '7', startTime: '15:55', endTime: '16:40' },
    { label: '8', startTime: '16:45', endTime: '17:30' },
    { label: '9', startTime: '19:00', endTime: '19:45' },
    { label: '10', startTime: '19:50', endTime: '20:35' }
  ];

  // 星期和日期
  private weekDays: WeekDay[] = [
    { day: '周一', date: '5/26' },
    { day: '周二', date: '5/27' },
    { day: '周三', date: '5/28' },
    { day: '周四', date: '5/29' },
    { day: '周五', date: '5/30' },
    { day: '周六', date: '5/31' },
    { day: '周日', date: '6/01' }
  ];

  aboutToAppear() {
    this.loadTestCourses();
  }

  loadTestCourses() {
    // 添加一些测试课程数据
    this.courses = [
      new CourseItem({ id: '1', name: '大数据技术', teacher: '陈益杉', classroom: '闻道109', weekDay: 4, timeSlot: 1, duration: 2, weekStart: 1, weekEnd: 18, color: '#FFB74D' }),
      new CourseItem({ id: '2', name: '机器学习', teacher: '谢润山', classroom: '闻道316', weekDay: 2, timeSlot: 3, duration: 2, weekStart: 1, weekEnd: 18, color: '#F48FB1' }),
      new CourseItem({ id: '3', name: '大数据技术', teacher: '陈益杉', classroom: '闻道109', weekDay: 1, timeSlot: 5, duration: 2, weekStart: 1, weekEnd: 18, color: '#FFB74D' }),
      new CourseItem({ id: '4', name: '鸿蒙应用开发', teacher: '曾鹏程', classroom: '九章209', weekDay: 2, timeSlot: 5, duration: 2, weekStart: 1, weekEnd: 18, color: '#81C784' }),
      new CourseItem({ id: '5', name: '鸿蒙实验课', teacher: '曾鹏程', classroom: '九章209', weekDay: 1, timeSlot: 7, duration: 2, weekStart: 1, weekEnd: 18, color: '#F8BBD9' }),
      new CourseItem({ id: '6', name: '鸿蒙应用开发', teacher: '曾鹏程', classroom: '九章209', weekDay: 2, timeSlot: 7, duration: 2, weekStart: 1, weekEnd: 18, color: '#81C784' }),
      new CourseItem({ id: '7', name: '机器学习', teacher: '谢润山', classroom: '闻道316', weekDay: 3, timeSlot: 7, duration: 2, weekStart: 1, weekEnd: 18, color: '#F48FB1' }),
      new CourseItem({ id: '8', name: '大数据实验课', teacher: '陈益杉', classroom: '九章402', weekDay: 1, timeSlot: 9, duration: 2, weekStart: 1, weekEnd: 18, color: '#FFB74D' }),
      new CourseItem({ id: '9', name: '机器学习实验', teacher: '谢润山', classroom: '九章403', weekDay: 4, timeSlot: 9, duration: 2, weekStart: 1, weekEnd: 18, color: '#F48FB1' })
    ];
  }

  // 获取指定位置的课程
  getCourseAtPosition(dayIndex: number, timeSlot: number, week: number): CourseItem | null {
    return this.courses.find((course: CourseItem) => 
      course.weekDay === dayIndex + 1 && 
      course.timeSlot === timeSlot && 
      course.isInWeek(week)
    ) || null;
  }

  // 上一周
  goToPreviousWeek(): void {
    if (this.currentWeek > this.startWeek) {
      this.swiperController.showPrevious();
    }
  }

  // 下一周
  goToNextWeek(): void {
    if (this.currentWeek < this.totalWeeks) {
      this.swiperController.showNext();
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('<')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width(24)
          .height(24)
          .textAlign(TextAlign.Center)
          .opacity(this.currentWeek > this.startWeek ? 1 : 0.3)
          .onClick(() => {
            this.goToPreviousWeek();
          })
        
        Text(`第${this.currentWeek}周`)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        
        Text('>')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width(24)
          .height(24)
          .textAlign(TextAlign.Center)
          .opacity(this.currentWeek < this.totalWeeks ? 1 : 0.3)
          .onClick(() => {
            this.goToNextWeek();
          })
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#FFFFFF')

      // 使用Swiper实现滑动切换
      Swiper(this.swiperController) {
        ForEach(this.weekNumbers, (week: number) => {
          this.WeekView(week)
        }, (week: number) => week.toString())
      }
      .index(this.currentWeek - this.startWeek)
      .indicator(false)
      .loop(false)
      .duration(300)
      .onChange((index: number) => {
        this.currentWeek = index + this.startWeek;
      })
      .layoutWeight(1)

      // 底部导航栏
      Row() {
        // 今日课程Tab
        Column() {
          Text('📚')
            .fontSize(20)
            .fontColor(this.currentTabIndex === 0 ? '#007AFF' : '#999999')
          Text('今日课程')
            .fontSize(12)
            .fontColor(this.currentTabIndex === 0 ? '#007AFF' : '#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentTabIndex = 0;
          // 可以在这里添加跳转到今日课程页面的逻辑
        })

        // 课程表Tab
        Column() {
          Text('📅')
            .fontSize(20)
            .fontColor(this.currentTabIndex === 1 ? '#007AFF' : '#999999')
          Text('课程表')
            .fontSize(12)
            .fontColor(this.currentTabIndex === 1 ? '#007AFF' : '#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentTabIndex = 1;
        })

        // 设置Tab
        Column() {
          Text('⚙️')
            .fontSize(20)
            .fontColor(this.currentTabIndex === 2 ? '#007AFF' : '#999999')
          Text('设置')
            .fontSize(12)
            .fontColor(this.currentTabIndex === 2 ? '#007AFF' : '#999999')
            .margin({ top: 2 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.currentTabIndex = 2;
          router.pushUrl({ url: 'pages/Settings' });
        })
      }
      .width('100%')
      .height(60)
      .backgroundColor('#FFFFFF')
      .border({ width: { top: 0.5 }, color: '#E5E5E5' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  WeekView(week: number) {
    Column() {
      // 星期和日期表头
      Row() {
        // 空白区域对应时间列
        Column()
          .width(50)
        
        // 星期表头
        ForEach(this.weekDays, (weekDay: WeekDay) => {
          Column() {
            Text(weekDay.day)
              .fontSize(14)
              .fontColor('#333333')
            Text(weekDay.date)
              .fontSize(12)
              .fontColor('#999999')
              .margin({ top: 2 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        }, (weekDay: WeekDay) => weekDay.day)
      }
      .width('100%')
      .height(50)
      .backgroundColor('#F8F8F8')

      // 课程表主体 - 使用Stack来放置悬浮按钮
      Stack({ alignContent: Alignment.BottomEnd }) {
        // 课程表内容
        Scroll() {
          Row() {
            // 左侧时间列
            Column() {
              ForEach(this.timeSlots, (timeSlot: TimeSlot) => {
                Column() {
                  Text(timeSlot.label)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                  Text(timeSlot.startTime)
                    .fontSize(10)
                    .fontColor('#666666')
                    .margin({ top: 2 })
                  Text(timeSlot.endTime)
                    .fontSize(10)
                    .fontColor('#666666')
                }
                .width(50)
                .height(80)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
              }, (timeSlot: TimeSlot) => timeSlot.label)
            }
            .alignItems(HorizontalAlign.Center)

            // 课程网格
            Column() {
              ForEach(this.timeSlots, (timeSlot: TimeSlot, timeIndex: number) => {
                Row() {
                  ForEach(this.weekDays, (weekDay: WeekDay, dayIndex: number) => {
                    this.CourseCell(dayIndex, parseInt(timeSlot.label), this.getCourseAtPosition(dayIndex, parseInt(timeSlot.label), week), week)
                  }, (weekDay: WeekDay) => `${weekDay.day}_${timeSlot.label}`)
                }
                .width('100%')
                .height(80)
              }, (timeSlot: TimeSlot) => `${timeSlot.label}_week${week}`)
            }
            .layoutWeight(1)
          }
        }
        .width('100%')
        .layoutWeight(1)

        // 悬浮添加按钮
        Button({ type: ButtonType.Circle }) {
          Text('+')
            .fontSize(24)
            .fontColor('#FFFFFF')
        }
        .width(56)
        .height(56)
        .backgroundColor('#007AFF')
        .margin({ right: 20, bottom: 80 }) // 避免与底部导航栏重叠
        .onClick(() => {
          router.pushUrl({ url: 'pages/CourseEdit' });
        })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  CourseCell(dayIndex: number, timeSlot: number, course: CourseItem | null, week: number) {
    Column() {
      if (course !== null) {
        Column() {
          Text(course.name)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Center)
            .width('100%')
            .lineHeight(16)
          
          Text(`@${course.classroom}`)
            .fontSize(10)
            .fontColor('#FFFFFF')
            .opacity(0.9)
            .margin({ top: 2 })
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Center)
            .width('100%')
          
          Blank() // 添加弹性空间，将内容推向顶部
        }
        .width('100%')
        .height(course.duration * 80 - 4)
        .backgroundColor(course.color)
        .borderRadius(6)
        .padding({ top: 6, bottom: 6, left: 3, right: 3 })
        .justifyContent(FlexAlign.Start) // 改为从顶部开始布局
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/CourseDetail',
            params: { courseId: course.id }
          });
        })
      } else {
        Column()
          .width('100%')
          .height(78)
          .backgroundColor('#FFFFFF')
          .border({ width: 0.5, color: '#E5E5E5' })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/CourseEdit',
              params: { 
                dayOfWeek: dayIndex + 1,
                timeSlot: timeSlot,
                week: week
              }
            });
          })
      }
    }
    .layoutWeight(1)
    .padding({ left: 1, right: 1, top: 1, bottom: 1 })
  }
}