import 'services/rider_service.dart';
import 'views/terminal_ui.dart';

void main() {
  RiderService riderService = RiderService();
  TerminalUI terminalUI = TerminalUI(riderService);
  terminalUI.start();
}
