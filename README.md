# AI Drive Assistant

## How to Use?

You can run the app by installing the apk file in the app-release.zip file on your Android smartphone.

##	Problem Definition


- Research indicates that a substantial proportion of traffic accidents, exceeding 50 percent, can be attributed to the failure of drivers to adhere to safe driving practices, including the neglect of forward observation, engagement in reckless driving behaviors, usage of mobile devices, and driving while fatigued. In response to this issue, our team has devised a service aimed at establishing an environment conducive to driver focus by actively monitoring driving conditions. The introduction of an artificial intelligence (AI) model functioning as a standalone assistant during solitary driving scenarios holds considerable promise, as it is anticipated to effectively address unforeseen circumstances and maintain a driver's emotional well-being and concentration at a consistently suitable level for safe driving.

- The application employs monitoring techniques to assess the user's condition and subsequently offers tailored services categorized as normal, drowsy driving, mobile phone manipulation, driver aggression, drunk driving, and object detection. The specific services provided based on the monitoring status are presented in the following table:

- The application's ability to classify the user's condition and offer appropriate services contributes to enhancing driver safety and reducing the occurrence of accidents associated with various risky driving behaviors.. 

|*Monitoring Status*|*Services*|
|:--:|:--:|
|Normal|Continuous monitoring|
|Drunk driving|Warning sounds and police reports|
|Driver assault|Warning sounds and police reports|
|Drowsy driving|An acting song|
|Mobile phone manipulation|A warning sound|
|Looking for things|A warning sound|


##	System Design(Project overview)

![Application demonstriation](/img/fig1.png)

- As illustrated in the diagram, the service delivery process involves capturing images, diagnosing the driver's state, confirming the state, and providing suitable services. To ensure the efficiency of the artificial intelligence (AI) model and the minimal data requirements for the application's operation, a channel-wise stacking technique is employed, where five photos are stacked as input data. Convolutional Neural Network (CNN)-based models are utilized for the AI models, and after training with TensorFlow, they are converted to TensorFlow Lite for mobile usage.
- The diagnostic status is determined through health monitoring, enabling the classification of the driver's condition. To avoid inaccurate service provision and to verify the driver's intention, a voice-based reconfirmation process is incorporated. During this phase, in order to draw attention to the driver's abnormal behavior, the application retrieves the name entered during the initial setup and uses it to address the driver, for example, "Mr. OOO, are you currently feeling drowsy?"
- Lastly, once the driver's condition is confirmed, appropriate services can be provided. This comprehensive process ensures accurate assessment and personalized assistance, enhancing the effectiveness of the application in promoting driver safety 


## Data

- The training data utilized for model learning originated from the publicly available "Driver and Passenger Status and Abnormal Behavior Monitoring" dataset, which is accessible on AI-hub. This dataset was specifically collected to facilitate the recognition of passenger situations within vehicles, aiding in the development and advancement of autonomous driving and infotainment AI services for vehicles.
- The dataset encompasses seven distinct classes of data, including drunk driving, driver assault, drowsy driving, cell phone manipulation, object finding, vehicle manipulation, and normal vehicle operation. Among these classes, the "normal" category represents instances of typical, non-aberrant vehicle operation.
- The original dataset comprises both images and corresponding labels. The image sequences have a duration ranging from 5 to 7 seconds, while the labels denote the specific abnormal behavior associated with each image sequence, as well as the driver's emotional state during that particular instance.
- To ensure real-time monitoring of the user's status through the application, the computational speed and volume of the artificial intelligence model are crucial considerations. However, utilizing image data can significantly impact the model's speed and computational requirements. To address this challenge, a solution involves capturing images at 1-second intervals over a duration of 5 seconds.
- By stacking these images, a 5x3 (RGB) matrix is formed, allowing the use of 5 images obtained within the 5-second timeframe as a single input. This approach mitigates the computational burden while maintaining a reasonable level of temporal information.
- The original image size is 720x1280, but for monitoring the user's condition via the application, the driver's portion of the original image is cropped to form a lower-resolution 720x480 image. This reduction in resolution contributes to optimizing the model's computational load, enhancing its overall efficiency.


## Deep Learning Model

- Preprocessing: To accommodate the usability of the application, adjustments need to be made to the data size and orientation. While the original data is acquired horizontally, it is preferable to monitor the data vertically in the application. To enable learning with longer data, padding can be added to the top and bottom of horizontally acquired photos, similar to the approach used in mobile applications.
- Model summary: The model architecture comprises a series of convolutional layers, ReLU activation functions, and Maxpooling layers. This combination is repeated five times to extract relevant features, followed by a fully connected layer for predicting the class labels.
- Hyperparameter: During the learning process, the Adam optimizer was utilized along with the cross-entropy loss function. The training was performed for 50 epochs, which represents the number of complete passes through the training dataset.
- Model training result: The training accuracy achieved was 93.23%, indicating a high level of performance on the training data. The validation accuracy reached 60.59%, indicating the model's ability to generalize to unseen data. Further optimization and fine-tuning may be required to improve the validation accuracy and enhance overall model performance.


## Mobile application

- The development of the application was carried out using the Flutter open-source framework, focusing on Android platform compatibility. The user interface (UI) design encompasses three distinct types. The initial UI involves user recognition through the input of a username (login) for identification purposes. The second UI serves as the main interface, overseeing the entire process and presenting the output and post-processing results. The third UI integrates the camera functionality.
- The overall process consists of several steps: camera photography, state diagnosis, state confirmation, and post-processing. In the camera photography step, a series of five photos is continuously captured at 1-second intervals, generating input for state diagnosis. The state diagnosis step utilizes a deep learning model converted to the TensorFlow Lite (tflite) format, allowing for efficient inference. The model assigns a corresponding label to the diagnosed state.
- The UI displays the label for the user to recognize their current state. Additionally, an audible confirmation question is posed (Text-to-Speech, TTS) based on the label, and the user's state is confirmed through voice recognition using a GPT-based system. In the post-processing stage, various interventions such as warnings and music playback are provided based on the diagnosed state (label). These interventions aim to address and mitigate potential risks associated with the identified state.


## Application Demonstration

![Application demonstriation](/img/fig3.png)

- demo video
https://www.youtube.com/watch?v=GsxRhvZkXbk

## Boarder Impacts

### Expected Effects: The implementation of the proposed service is anticipated to yield several positive outcomes:
- Improved driver focus and hazard protection: By assisting drivers in maintaining focus on the road and alerting them to potential hazards, the service can contribute to reducing driver distractions and enhancing overall road safety.
- Reduction in driver accident rates: With the monitoring and assistance provided by the application, it is expected that the occurrence of accidents caused by unsafe driving behaviors will decrease, leading to a reduction in driver accident rates.

### Economic Effects: Introducing the service as a subscription-based offering for taxi or chauffeur services can have economic benefits
- Increased demand for taxi and chauffeur services: Drivers undertaking long drives or serving customers may benefit from the app's assistance in maintaining concentration. This can result in improved customer satisfaction and increased demand for these services.
- Enhancing safety for taxi and chauffeur drivers: The automatic reporting function in case of customer assault can facilitate a swift and secure response to violence, ensuring the safety of drivers. This can attract more drivers to work for taxi or proxy driving platforms, knowing that their well-being is prioritized.
- Enhanced trust and confidence in transportation services: Integrating the service with a taxi or proxy driving platform allows customers to access monitoring results and driving history of deployed drivers. This transparency can build trust and confidence in transportation services, encouraging customers to utilize the service with assurance.
- Overall, the combination of improved driver safety, increased demand for transportation services, and enhanced customer confidence can result in positive economic effects for the service providers and the industry as a whole.

## Future Works
- Addressing the limitations of music playback posed a challenge due to copyright restrictions and existing application limitations. To enhance the music playback feature, it is recommended to explore and implement solutions that provide access to a wider range of music applications. One potential solution could be leveraging the Spotify module, which could offer additional functionalities and improve the selection of music choices for users. By adopting such solutions, users' experience would be enhanced with a broader range of music options available.
- Mitigating distracted driving caused by smartphone usage: Many drivers tend to engage with their smartphones for navigation purposes, leading to distracted driving. Considering that the majority of monitoring results yield normal states, there is an opportunity to provide specific services to address this issue more effectively. To facilitate efficient monitoring and reduce smartphone usage while driving, it is crucial to encourage and promote alternative methods of navigation, such as voice-guided systems or integrating with existing navigation apps that prioritize driver safety.
- There is a need to gather more information beyond just the driver's name. Having access to additional driver information can facilitate quicker and more accurate reporting in situations where police intervention or reporting is required. This would enable the application to provide more comprehensive and timely assistance to the driver when needed.
