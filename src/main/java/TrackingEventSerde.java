import io.jp.Protos;
import org.apache.flink.api.common.typeinfo.TypeInformation;
import org.apache.flink.streaming.util.serialization.DeserializationSchema;
import org.apache.flink.streaming.util.serialization.SerializationSchema;

import java.io.IOException;

/**
 * Serialization and deserialization of tracking events using Protobuf.
 */
public class TrackingEventSerde implements SerializationSchema<Protos.TrackingEvent>, DeserializationSchema<Protos.TrackingEvent> {

    @Override
    public byte[] serialize(Protos.TrackingEvent element) {
        return element.toByteArray();
    }

    @Override
    public Protos.TrackingEvent deserialize(byte[] message) throws IOException {
        return Protos.TrackingEvent.parseFrom(message);
    }

    @Override
    public boolean isEndOfStream(Protos.TrackingEvent nextElement) {
        return false; // infinite
    }

    @Override
    public TypeInformation<Protos.TrackingEvent> getProducedType() {
        return TypeInformation.of(Protos.TrackingEvent.class);
    }

}
