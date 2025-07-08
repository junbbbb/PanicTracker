# Features Documentation

## Core Features

### 1. Anxiety Entry Tracking
- **Location**: `lib/features/entry/`
- **Description**: Create, read, update, and delete anxiety episodes
- **Data Model**: AnxietyEntry
  - `timestamp`: When the episode occurred
  - `trigger`: What caused the anxiety
  - `symptoms`: List of physical/emotional symptoms
  - `negativeThoughts`: Negative thought patterns
  - `copingStrategy`: How the user dealt with the episode
  - `durationInMinutes`: How long the episode lasted

### 2. Home Dashboard
- **Location**: `lib/features/home/`
- **Description**: Overview of recent activity and statistics
- **Components**:
  - Summary cards with weekly statistics
  - Recent entries list
  - Quick access to add new entries

### 3. History Management
- **Location**: `lib/features/history/`
- **Description**: View and manage all past anxiety entries
- **Features**:
  - Chronological list of all entries
  - Expandable cards with full entry details
  - Search and filter capabilities (future enhancement)

### 4. Data Analysis
- **Location**: `lib/features/analysis/`
- **Description**: Visual insights and patterns analysis
- **Charts**:
  - Line chart: Episodes over time (30-day trend)
  - Bar chart: Duration distribution
  - List: Most common triggers
- **Library**: fl_chart

### 5. Profile & Export
- **Location**: `lib/features/profile/`
- **Description**: User preferences and data export
- **Export Options**:
  - CSV format for spreadsheet analysis
  - JSON format for data backup
- **Privacy**: All data stored locally

## Navigation Structure
- **Bottom Tab Bar**: 5 main sections
  - Home: Dashboard and summary
  - History: Past entries
  - Add Entry: Center tab with + icon
  - Analysis: Charts and insights
  - Profile: Settings and export

## Data Persistence
- **Local Database**: Hive (NoSQL)
- **Benefits**: Fast, lightweight, offline-first
- **Models**: Auto-generated adapters for type safety

## User Experience
- **Design**: Clean, modern UI inspired by Stripe/Airbnb
- **Accessibility**: Proper contrast, readable fonts
- **Responsiveness**: Optimized for various screen sizes
- **Validation**: Form validation with clear error messages

## Future Enhancements
- Reminder notifications
- Advanced filtering and search
- Data backup to cloud
- Export to PDF reports
- Integration with health apps
- Machine learning insights