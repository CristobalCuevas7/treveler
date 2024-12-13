import 'package:treveler/domain/entities/booking.dart';
import 'package:treveler/domain/entities/result.dart';
import 'package:treveler/domain/repositories/booking_repository.dart';

class GetAllBookingsUseCase {
  final BookingRepository _bookingRepository;

  GetAllBookingsUseCase(this._bookingRepository);

  Future<Result<List<Booking>>> execute() async {
    try {
      Result<List<Booking>> result = await _bookingRepository.getAllBooking();

      return result.fold(onSuccess: (bookingList) {
        bookingList.sort((a, b) => b.created.compareTo(a.created));
        return Success(bookingList);
      }, onFailure: (message, error) {
        return result;
      });
    } catch (error) {
      return const Failure(message: "Unexpected error");
    }
  }
}
