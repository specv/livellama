defmodule LiveLlamaWeb.ChatsLive.PromptMessagesComponent do
  use LiveLlamaWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex-1 space-y-6 overflow-y-auto rounded-xl bg-slate-200 p-4 text-sm leading-6 text-slate-900 shadow-sm dark:bg-slate-900 dark:text-slate-300 sm:text-base sm:leading-7">
      <div class="flex items-start">
        <img
          class="mr-2 h-8 w-8 rounded-full"
          src="https://dummyimage.com/128x128/363536/ffffff&text=J"
        />
        <div class="flex rounded-b-xl rounded-tr-xl bg-slate-50 p-4 dark:bg-slate-800 sm:max-w-md md:max-w-2xl">
          <p>Explain quantum computing in simple terms</p>
        </div>
      </div>
      <div class="flex flex-row-reverse items-start">
        <img
          class="ml-2 h-8 w-8 rounded-full"
          src="https://dummyimage.com/128x128/354ea1/ffffff&text=G"
        />

        <div class="flex min-h-[85px] rounded-b-xl rounded-tl-xl bg-slate-50 p-4 dark:bg-slate-800 sm:min-h-0 sm:max-w-md md:max-w-2xl">
          <p>
            Certainly! Quantum computing is a new type of computing that relies on
            the principles of quantum physics. Traditional computers, like the one
            you might be using right now, use bits to store and process information.
            These bits can represent either a 0 or a 1. In contrast, quantum
            computers use quantum bits, or qubits.<br /><br />
            Unlike bits, qubits can represent not only a 0 or a 1 but also a
            superposition of both states simultaneously. This means that a qubit can
            be in multiple states at once, which allows quantum computers to perform
            certain calculations much faster and more efficiently
          </p>
        </div>
        <div class="mr-2 mt-1 flex flex-col-reverse gap-2 text-slate-500 sm:flex-row">
          <button class="hover:text-blue-600" type="button">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M8 8m0 2a2 2 0 0 1 2 -2h8a2 2 0 0 1 2 2v8a2 2 0 0 1 -2 2h-8a2 2 0 0 1 -2 -2z">
              </path>
              <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
            </svg>
          </button>
          <button class="hover:text-blue-600" type="button">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M7 13v-8a1 1 0 0 0 -1 -1h-2a1 1 0 0 0 -1 1v7a1 1 0 0 0 1 1h3a4 4 0 0 1 4 4v1a2 2 0 0 0 4 0v-5h3a2 2 0 0 0 2 -2l-1 -5a2 3 0 0 0 -2 -2h-7a3 3 0 0 0 -3 3">
              </path>
            </svg>
          </button>
          <button class="hover:text-blue-600">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M7 11v8a1 1 0 0 1 -1 1h-2a1 1 0 0 1 -1 -1v-7a1 1 0 0 1 1 -1h3a4 4 0 0 0 4 -4v-1a2 2 0 0 1 4 0v5h3a2 2 0 0 1 2 2l-1 5a2 3 0 0 1 -2 2h-7a3 3 0 0 1 -3 -3">
              </path>
            </svg>
          </button>
        </div>
      </div>
      <div class="flex items-start">
        <img
          class="mr-2 h-8 w-8 rounded-full"
          src="https://dummyimage.com/128x128/363536/ffffff&text=J"
        />
        <div class="flex rounded-b-xl rounded-tr-xl bg-slate-50 p-4 dark:bg-slate-800 sm:max-w-md md:max-w-2xl">
          <p>What are three great applications of quantum computing?</p>
        </div>
      </div>
      <div class="flex flex-row-reverse items-start">
        <img
          class="ml-2 h-8 w-8 rounded-full"
          src="https://dummyimage.com/128x128/354ea1/ffffff&text=G"
        />
        <div class="flex min-h-[85px] rounded-b-xl rounded-tl-xl bg-slate-50 p-4 dark:bg-slate-800 sm:min-h-0 sm:max-w-md md:max-w-2xl">
          <p>
            Three great applications of quantum computing are: Optimization of
            complex problems, Drug Discovery and Cryptography.
          </p>
        </div>
        <div class="mr-2 mt-1 flex flex-col-reverse gap-2 text-slate-500 sm:flex-row">
          <button class="hover:text-blue-600" type="button">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M8 8m0 2a2 2 0 0 1 2 -2h8a2 2 0 0 1 2 2v8a2 2 0 0 1 -2 2h-8a2 2 0 0 1 -2 -2z">
              </path>
              <path d="M16 8v-2a2 2 0 0 0 -2 -2h-8a2 2 0 0 0 -2 2v8a2 2 0 0 0 2 2h2"></path>
            </svg>
          </button>
          <button class="hover:text-blue-600" type="button">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M7 13v-8a1 1 0 0 0 -1 -1h-2a1 1 0 0 0 -1 1v7a1 1 0 0 0 1 1h3a4 4 0 0 1 4 4v1a2 2 0 0 0 4 0v-5h3a2 2 0 0 0 2 -2l-1 -5a2 3 0 0 0 -2 -2h-7a3 3 0 0 0 -3 3">
              </path>
            </svg>
          </button>
          <button class="hover:text-blue-600">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="h-5 w-5"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
              <path d="M7 11v8a1 1 0 0 1 -1 1h-2a1 1 0 0 1 -1 -1v-7a1 1 0 0 1 1 -1h3a4 4 0 0 0 4 -4v-1a2 2 0 0 1 4 0v5h3a2 2 0 0 1 2 2l-1 5a2 3 0 0 1 -2 2h-7a3 3 0 0 1 -3 -3">
              </path>
            </svg>
          </button>
        </div>
      </div>
    </div>
    """
  end
end
