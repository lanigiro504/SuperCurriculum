import { CourseItem, UserConfig } from '../models/CourseModel';
import { CloudDBService } from './CloudDBService';
import { NotificationService } from './NotificationService';

export class CourseService {
  private cloudDBService: CloudDBService = new CloudDBService();
  private notificationService: NotificationService = new NotificationService();
  
  // 获取指定周次的所有课程
  async getCoursesByWeek(week: number): Promise<CourseItem[]> {
    const allCourses = await this.cloudDBService.getAllCourses();
    return allCourses.filter(course => course.isInWeek(week));
  }
  
  // 获取指定日期的课程
  async getCoursesByDate(date: Date): Promise<CourseItem[]> {
    const weekDay = date.getDay() === 0 ? 7 : date.getDay(); // 转换为1-7，1表示周一
    const currentWeek = this.getCurrentWeek(date);
    
    const weekCourses = await this.getCoursesByWeek(currentWeek);
    return weekCourses.filter(course => course.weekDay === weekDay);
  }
  
  // 获取当前是第几周
  getCurrentWeek(date: Date = new Date()): number {
    // 假设第一周的开始日期是固定的，这里简化处理
    // 实际应用中应该从数据库或用户配置中获取学期开始时间
    const termStartDate = new Date('2023-09-01');
    const diffDays = Math.floor((date.getTime() - termStartDate.getTime()) / (1000 * 60 * 60 * 24));
    const currentWeek = Math.floor(diffDays / 7) + 1;
    
    return Math.max(1, Math.min(currentWeek, 20)); // 限制在1-20周
  }
  
  // 添加新课程
  async addCourse(course: CourseItem): Promise<boolean> {
    const result = await this.cloudDBService.insertCourse(course);
    if (result) {
      this.scheduleNotifications();
    }
    return result;
  }
  
  // 更新课程
  async updateCourse(course: CourseItem): Promise<boolean> {
    const result = await this.cloudDBService.updateCourse(course);
    if (result) {
      this.scheduleNotifications();
    }
    return result;
  }
  
  // 删除课程
  async deleteCourse(courseId: string): Promise<boolean> {
    const result = await this.cloudDBService.deleteCourse(courseId);
    if (result) {
      this.scheduleNotifications();
    }
    return result;
  }
  
  // 获取用户配置
  async getUserConfig(): Promise<UserConfig> {
    return await this.cloudDBService.getUserConfig();
  }
  
  // 更新用户配置
  async updateUserConfig(config: UserConfig): Promise<boolean> {
    const result = await this.cloudDBService.updateUserConfig(config);
    if (result) {
      this.scheduleNotifications();
    }
    return result;
  }
  
  // 安排课程通知
  private async scheduleNotifications(): Promise<void> {
    const config = await this.getUserConfig();
    if (!config.enableNotification) {
      this.notificationService.cancelAllNotifications();
      return;
    }
    
    const today = new Date();
    const nextWeek = new Date(today);
    nextWeek.setDate(today.getDate() + 7);
    
    // 获取未来一周的课程
    const currentWeek = this.getCurrentWeek(today);
    const nextWeekNum = this.getCurrentWeek(nextWeek);
    
    let courses: CourseItem[] = [];
    for (let week = currentWeek; week <= nextWeekNum; week++) {
      const weekCourses = await this.getCoursesByWeek(week);
      courses = courses.concat(weekCourses);
    }
    
    // 为每节课程安排通知
    this.notificationService.scheduleCourseNotifications(courses, config.advanceMinutes);
  }
}
