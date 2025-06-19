import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { CourseService } from '../main/ets/services/CourseService';
import { CourseItem, UserConfig } from '../main/ets/models/CourseModel';

export default function courseServiceTest() {
  describe('CourseService Test', () => {
    let courseService: CourseService;
    
    beforeAll(() => {
      // 在所有测试用例开始前执行一次
      courseService = new CourseService();
    });
    
    beforeEach(() => {
      // 每个测试用例开始前执行
    });
    
    afterEach(() => {
      // 每个测试用例结束后执行
    });
    
    afterAll(() => {
      // 所有测试用例结束后执行一次
    });
    
    it('Should get courses by week', 0, async () => {
      const courses = await courseService.getCoursesByWeek(1);
      expect(courses.length).assertLargerThan(0);
    });
    
    it('Should get current week', 0, () => {
      const currentWeek = courseService.getCurrentWeek();
      expect(currentWeek).assertLargerThanOrEqual(1);
      expect(currentWeek).assertLessThanOrEqual(20);
    });
    
    it('Should get courses by date', 0, async () => {
      const today = new Date();
      const courses = await courseService.getCoursesByDate(today);
      expect(courses).assertInstanceOf(Array);
    });
    
    it('Should get user config', 0, async () => {
      const config = await courseService.getUserConfig();
      expect(config).assertInstanceOf(UserConfig);
      expect(config.enableNotification).assertInstanceOf(Boolean);
      expect(config.advanceMinutes).assertInstanceOf(Number);
    });
  });
}
