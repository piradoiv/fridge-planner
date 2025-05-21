# FridgePlanner

**FridgePlanner** is a simple iOS meal planning app built with Xojo for the May 2025 open-source challenge. It helps you plan lunch and dinner for a month, replacing paper or Excel-based planners with a mobile solution. The app allows you to duplicate previous months, swap meals between days, auto-save meals for reuse, and export a black-and-white A4 PDF for printing and attaching to your fridge. Designed for daily use, FridgePlanner is lightweight, offline, and user-friendly, showcasing Xojo’s rapid development capabilities for iOS apps.

## Features
- **Monthly Calendar View**: Displays a month’s meal plan in a grid, showing lunch and dinner for each day.
- **Auto-Saved Meal Library**: Automatically saves meals for reuse, with separate lists for lunch and dinner (e.g., “Tacos” only for dinner).
- **PDF Export**: Generate a black-and-white A4 PDF of the monthly plan, optimized for printing and fridge attachment.
- **Offline Storage**: Uses SQLite for local storage, ensuring reliability without internet.

## Planned features
- **Duplicate Previous Month**: Copy the prior month’s plan to quickly start planning.
- **Meal Swapping**: Drag-and-drop to swap lunch or dinner between days (e.g., swap Monday’s lunch with Wednesday’s lunch).
- **Notes**: Add optional notes per day (e.g., “Prep lasagna night before”).
- Check the [Issues](https://github.com/piradoiv/fridge-planner/issues) section for more, feel free to create some feature requests!

## Some Screenshots
![screenshot-1](https://github.com/user-attachments/assets/528c886c-d469-4a66-b308-fe0235e0e58d)    
![screenshot-2](https://github.com/user-attachments/assets/69befb13-1447-48a5-813c-77d3773a3f7d)    
![screenshot-3](https://github.com/user-attachments/assets/a45555e1-41c7-4865-b93c-f528e611698d)    
![screenshot-4](https://github.com/user-attachments/assets/2c36a70b-2718-4f2c-a780-262c02f7f13c)

## Calendar printed directly from the app
![printed-calendar](https://github.com/user-attachments/assets/d9c725c9-b14e-40e3-811e-23770db001f3)

## Requirements
- **Xojo**: Version 2025r2 or later (with iOS support).

## Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/piradoiv/fridge-planner.git
   ```
2. **Open in Xojo**:
   - Launch Xojo and open the `MealPlanner.xojo_project` file.
3. **Build and Run**:
   - Connect an iOS device or use the iOS Simulator.
   - Build and run the project in Xojo.

## Usage
1. **View Calendar**:
   - The main screen shows the current month’s meal plan (e.g., May 2025).
   - Each day lists lunch and dinner (e.g., “May 1: Lunch: Pasta, Dinner: Tacos”).
   - Use `<<` and `>>` buttons to navigate months.
2. **Edit Meals**:
   - Tap a day and use the table under the calendar for adding meals
   - Select lunch or dinner from pre-saved meals or enter new ones (automatically saved to the library).
3. **Export PDF**:
   - Press “Generate PDF” to generate an A4 black-and-white plan for printing.
   - Share via email, AirDrop, save or print for fridge attachment.

## Contributing
Contributions to FridgePlanner are welcomed! To contribute:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request with a description of your changes.

Please follow these guidelines:
- Use [Xojo coding conventions](https://documentation.xojo.com/topics/code_management/coding_guidelines.html).
- Test changes in the iOS Simulator or on a device.
- Update documentation for new features.
- Focus on simplicity and offline functionality.

Ideas for contributions:
- Enhance PDF export layout.
- Add grocery list generation.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For questions or suggestions, open an issue on GitHub.

---

Happy meal planning with FridgePlanner!
