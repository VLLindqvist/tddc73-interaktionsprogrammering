import { StatusBar } from 'expo-status-bar'
import Constants from 'expo-constants'
import React, { useRef, useState } from 'react'
import { StyleSheet, Text, View, Image, TouchableOpacity, TextInput, findNodeHandle } from 'react-native'
import androidIcon from './assets/android.png'

const App = () => {
  const emailInput = useRef<TextInput>(null)
  const [ email, setEmail ] = useState<string>("")

  return (
    <View style={styles.container}>
      <View style={styles.imageWrap}>
        <Image source={androidIcon} style={styles.image} />
      </View>
      <View style={styles.buttonWrap}>
        <View style={styles.buttonContainer}>
          <Button
            title="BUTTON"
            onPress={() => {}}
          />
          <Button
            title="BUTTON"
            onPress={() => {}}
          />
        </View>
        <View style={styles.buttonContainer}>
          <Button
            title="BUTTON"
            onPress={() => {}}
          />
          <Button
            title="BUTTON"
            onPress={() => {}}
          />
        </View>
      </View>
      <View style={styles.emailWrap}>
        <Text onPress={() => { emailInput.current && emailInput.current.focus()}}>
          Email
        </Text>
        <TextInput
          ref={emailInput}
          autoFocus
          keyboardType="email-address"
          autoCompleteType="email"
          style={styles.textInput}
          onChangeText={text => setEmail(text)}
          value={email}
        />
      </View>
      <StatusBar style="auto" />
    </View>
  );
}

const Button = ({ title, onPress, ...rest }: { title: string, onPress?: () => void, rest?: object }) => (
  <TouchableOpacity
    accessibilityRole="button"
    onPress={onPress}
  >
    <View style={styles.button}>
      <Text style={styles.buttonText}>
        {title}
      </Text>
    </View>
  </TouchableOpacity>
)

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'flex-start',
    marginTop: Constants.statusBarHeight,
  },
  imageWrap: {
    marginTop: 10,
    height: 150,
  },
  image: {
    flex: 1,
    aspectRatio: 1.5, 
    resizeMode: 'contain',
  },
  buttonWrap: {
    display: "flex",
    justifyContent: "center",
    width: "100%"
  },
  buttonContainer: {
    margin: 16,
    display: "flex",
    flexDirection: "row",
    justifyContent: "space-around",
    alignItems: "center",
  },
  button: {
    elevation: 4,
    // Material design blue from https://material.google.com/style/color.html#color-color-palette
    backgroundColor: '#ededed',
    borderRadius: 2,
  },
  buttonText: {
    textAlign: 'center',
    margin: 8,
    color: '#000',
    fontWeight: '500',
  },
  emailWrap: {
    marginTop: 20,
    display: "flex",
    flexDirection: "row",
    justifyContent: "center",
    alignItems: "center",
    width: "100%"
  },
  textInput: {
    marginLeft: "7%",
    width: "70%",
    height: 40,
    borderBottomWidth: 2,
    borderBottomColor: "#ededed",
  },
});

export default App