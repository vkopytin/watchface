function performanceStatisticsComponentCreate() as PerformanceStatisticsComponent {
    var inst = new PerformanceStatisticsComponent();
    return inst;
}

class PerformanceStatisticsComponent {
    var renderMs = 0;
    var updateMs = 0;
    var totalMs = 0;
}
