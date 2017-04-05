import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaProducer010;

import java.util.Properties;

/**
 * Created by johnnypark on 13/03/2017.
 */
public class TrackingEventProducer {

    private static final int NUMBER_MESSAGES = 10000;
    private static final String TOPIC = "tracking";

    public static void main(String[] args) throws Exception {


        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
        Properties properties = new Properties();
        properties.setProperty("bootstrap.servers", "localhost:9092");
        env
                .addSource(new TrackingEventSource(NUMBER_MESSAGES))
                .map(trackingEvent -> trackingEvent.toByteArray())
                .addSink(new FlinkKafkaProducer010<byte[]>(TOPIC, new ByteSerialisationSchema(), properties));
        env.execute();
    }
}
